;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; Start at 14pt (Emacs's default is 12pt). Size only, no :family, so the default
;; font family is preserved. Tweak the number to taste; re-apply with
;; `M-x doom/reload-font' or on the next restart.
(setq doom-font (font-spec :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function.
;;
;; Goal: GUI frames get Doom's own dark palette (doom-one); terminal frames get
;; NO theme, so they inherit the terminal emulator's color scheme (its 16 ANSI
;; colors + default faces).
;;
;; We pick the theme PER FRAME rather than once at startup because this Emacs
;; runs as a daemon (emacsclient connects to it). The daemon evaluates this file
;; with no display attached, so a one-shot `(display-graphic-p)' check here is
;; always nil — every client, GUI included, would inherit no theme (the light
;; default). Deciding at frame-creation time fixes that.
;;
;; Caveat: Emacs themes are global to one Emacs process, so if a GUI client and a
;; terminal client are attached to the SAME daemon simultaneously, the most
;; recently created frame wins. In practice GUI and TTY are used at different
;; times, so this is fine.
(setq doom-theme nil)            ; don't let Doom auto-load at startup; we manage it

(defun +my/theme-for-frame (&optional frame)
  "Load `doom-one' on graphical FRAMEs; strip themes on TTY frames.
TTY frames are left bare so they inherit the terminal's own ANSI colors."
  (if (display-graphic-p frame)
      (unless (memq 'doom-one custom-enabled-themes)
        (load-theme 'doom-one t))
    (dolist (th (copy-sequence custom-enabled-themes))
      (disable-theme th))))

(add-hook 'after-make-frame-functions #'+my/theme-for-frame)
(add-hook 'server-after-make-frame-hook #'+my/theme-for-frame)
(unless (daemonp)                ; non-daemon launch: theme the already-open frame
  (+my/theme-for-frame))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Roam/")
(setq org-roam-directory "~/Roam/")
(setq org-roam-db-location "~/Roam/org-roam.db")

;; Sidecars are named <artifact>.org, so a name like "page.html.org" matches
;; Emacs's composite-suffix html pattern ("\\.[sx]?html?\\(\\.[a-zA-Z_]+\\)?\\'"
;; -> mhtml-mode) before the org rule. Force-prepend an org entry so the final
;; .org extension always wins. `push', not `add-to-list': the same pair already
;; exists further down the alist, so add-to-list would (and did) no-op.
(push '("\\.org\\'" . org-mode) auto-mode-alist)

;; --- External handoff for file types Emacs can't usefully open ---------------
;; Visiting these only trips the large-file prompt and then dumps binary, so
;; route them out at the find-file choke point (treemacs, dired, and SPC f f
;; all funnel through it). Media plays in the default app; archives and disk
;; images reveal in Finder — NOT `open', which would silently extract a zip.
;; Deliberately in Emacs still: images (image-mode), PDFs (pdf-view), tarballs
;; (tar-mode browses them), and compressed text (jka-compr).
(defconst +my/external-play-re
  "\\.\\(mkv\\|mp4\\|m4v\\|mov\\|avi\\|webm\\|mp3\\|m4a\\|aac\\|flac\\|wav\\|ogg\\|opus\\|aiff\\)\\'"
  "File extensions handed to the system default app.")
(defconst +my/external-reveal-re
  "\\.\\(zip\\|7z\\|rar\\|dmg\\|iso\\|pkg\\)\\'"
  "File extensions revealed in Finder instead of visited.")
;; Content awareness: when the NAME says nothing (no match above, no
;; auto-mode-alist entry either), ask file(1) for the MIME type and route on
;; the substance. The sniff runs only on that unknown remainder, so ordinary
;; opens never pay the subprocess.
(defconst +my/mime-reveal-set
  '("application/zip" "application/x-7z-compressed" "application/vnd.rar"
    "application/x-rar" "application/x-iso9660-image"
    "application/x-apple-diskimage" "application/x-xar")
  "MIME types revealed in Finder when found by content sniffing.")

(defun +my/file-mime-type (f)
  "MIME type of local regular file F per file(1), or nil."
  (when (and (file-regular-p f) (not (file-remote-p f)))
    (with-temp-buffer
      (when (eq 0 (call-process "file" nil t nil "--brief" "--mime-type" "--" f))
        (string-trim (buffer-string))))))

(defun +my/external-route-for (f)
  "Decide how to handle F: `play', `reveal', or nil to visit normally."
  (let ((name (downcase f)))
    (cond
     ((string-match-p +my/external-play-re name) 'play)
     ((string-match-p +my/external-reveal-re name) 'reveal)
     ;; Name gave no answer and Emacs has no mode for it: sniff the content.
     ((not (assoc-default f auto-mode-alist #'string-match))
      (when-let ((mime (+my/file-mime-type f)))
        (cond ((string-match-p "\\`\\(video\\|audio\\)/" mime) 'play)
              ((member mime +my/mime-reveal-set) 'reveal)))))))

(defun +my/find-file-route-external (orig filename &rest args)
  "Route media and archives out of Emacs; visit everything else via ORIG."
  (let ((f (expand-file-name filename)))
    (pcase (+my/external-route-for f)
      ('play (call-process "open" nil 0 nil f)
             (message "Opened externally: %s" (file-name-nondirectory f)))
      ('reveal (call-process "open" nil 0 nil "-R" f)
               (message "Revealed in Finder: %s" (file-name-nondirectory f)))
      (_ (apply orig filename args)))))
(advice-add 'find-file :around #'+my/find-file-route-external)
(advice-add 'find-file-other-window :around #'+my/find-file-route-external)

;; --- POSIX config files Emacs doesn't map out of the box ---------------------
;; Stock coverage is decent (*.conf -> conf-mode-maybe, fstab/hosts/.ini all
;; mapped); these fill the gaps that actually occur on our systems. String
;; matching works over TRAMP too, where the MIME sniff deliberately doesn't.
(dolist (entry '(("/sshd?_config\\'" . conf-space-mode)           ; OpenSSH client + daemon
                 ("/hostname\\.[a-z]+[0-9]+\\'" . conf-space-mode) ; OpenBSD hostname.<if>
                 ("\\.cnf\\'" . conf-mode)                         ; MySQL-style conf
                 ("\\.\\(?:service\\|socket\\|timer\\|mount\\|target\\|slice\\)\\'"
                  . conf-unix-mode)))                              ; systemd units
  (push entry auto-mode-alist))

;; Any remaining undetermined file opens as text, not fundamental-mode.
(setq-default major-mode 'text-mode)


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; --- Faster org / org-roam linking ---
;; Complete any word at point into an [[id:][Title]] node link (the Obsidian-[[ feel).
;; Trigger with your completion key (TAB / corfu popup) on a word.
(after! org-roam
  (setq org-roam-completion-everywhere t))

;; SPC m l c — paste a clipboard URL as a [[url][Page Title]] link (fetches the title).
(map! :after org :map org-mode-map
      :localleader "l c" #'org-cliplink)

;; Toggle raw vs. descriptive link markup buffer-wide (org buffers only) — org's
;; analog of Obsidian's source/preview toggle. Bound on two keys so the same
;; physical keystroke works everywhere:
;;   M-e — Meta-e. In the terminal "Cmd-E" arrives as Meta (ESC e); in the GUI
;;         this is Option-e (`ns-option-modifier' is meta). Shadows
;;         `forward-sentence' in org buffers.
;;   s-e — super-e, i.e. Cmd-E in the GUI (`ns-command-modifier' is super).
;;         Globally Cmd-E is `isearch-yank-kill'; we shadow it inside org buffers
;;         only. Terminals can't emit super, so this binding is effectively
;;         GUI-only and doesn't touch the terminal.
(map! :after org :map org-mode-map
      "M-e" #'org-toggle-link-display
      "s-e" #'org-toggle-link-display)

;; --- Live-preview: reveal markup of the element under the cursor ---
;; Guarded with condition-case so any failure inside org-appear is caught and
;; logged to *Messages* instead of aborting org-mode-hook (which would disable
;; font-lock and leave the whole buffer unfontified, as happened before).
(use-package! org-appear
  :commands org-appear-mode
  :init
  (add-hook 'org-mode-hook
            (lambda ()
              (condition-case err
                  (org-appear-mode 1)
                (error (message "org-appear failed to start: %S" err)))))
  :config
  (setq org-appear-autolinks t
        org-appear-autoemphasis t
        org-appear-autosubmarkers t
        org-appear-trigger 'always))

;; Register the docview: link type (Doom nils `org-modules', dropping ol-docview —
;; without it org mis-reads docview: links as fuzzy targets, hence the earlier
;; "create as a new heading?" prompt), then follow docview: links inside Emacs:
;; the PDF opens in the other window, pdf-view jumps to the ::page, and the note
;; you followed from stays visible. Pages render as images but the text layer
;; stays live (isearch, selection, copy). The earlier Skim/AppleScript routing
;; dated from terminal-only use, where pages could not render at all; GUI Emacs
;; with a built epdfinfo replaced it (2026-07-21).
(after! org
  (require 'ol-docview)
  (org-link-set-parameters
   "docview"
   :follow
   (lambda (link _)
     (when (string-match "\\`\\(.*?\\)\\(?:::\\([0-9]+\\)\\)?\\'" link)
       (let ((path (expand-file-name (match-string 1 link)))
             (page (and (match-string 2 link)
                        (string-to-number (match-string 2 link)))))
         (find-file-other-window path)
         (when page
           (cond ((derived-mode-p 'pdf-view-mode) (pdf-view-goto-page page))
                 ((derived-mode-p 'doc-view-mode) (doc-view-goto-page page)))))))))

;; macOS GUI: make the left Option key Meta, so M- bindings (like M-e) work in the
;; GUI the way they do in the terminal — where Meta arrives as ESC. Keep the right
;; Option for typing accented characters. Inert in the terminal.
(when (eq system-type 'darwin)
  (setq ns-option-modifier 'meta
        ns-right-option-modifier 'none))

;; Basic terminal mouse (click to place point, drag to select, wheel to scroll) —
;; like nvim's `mouse=a'. tmux already forwards events (`mouse on'); this makes
;; Emacs request and handle them. No-op in GUI, which has native mouse already.
(xterm-mouse-mode 1)

;; Stop org's auto-indentation from mangling hand-formatted YAML in :EXTENDED:
;; (and other) drawers. `org-adapt-indentation' nil = don't reflow body text to
;; the headline; disabling electric-indent = RET won't re-indent the new line.
;; Indent YAML with spaces by hand; avoid TAB inside the block (it's org-cycle).
(after! org
  (setq org-adapt-indentation nil)
  (add-hook 'org-mode-hook (lambda () (electric-indent-local-mode -1))))

;; --- Dynamic block: the policies that extend this procedure ------------------
;; A policy declares the procedure(s) it constrains in an :EXTENDS: property of
;; quoted id links; a procedure's block is the reverse lookup. Only procedures
;; carry the block --- other files get their policies through directory scope
;; (see the "Folder Notes" policy and the Tools/context tool).
(defun org-dblock-write:policies (_params)
  "Write a table of the Policy nodes whose :EXTENDS: names this file's node.
Use as a dynamic block:  #+BEGIN: policies / #+END:  then refresh with C-c C-c."
  (let ((self (ignore-errors (org-roam-node-id (org-roam-node-at-point))))
        rows)
    (when self
      (dolist (r (org-roam-db-query
                  [:select [id title properties level] :from nodes]))
        (pcase-let ((`(,id ,title ,props ,level) r))
          (let ((extends (cdr (assoc "EXTENDS" props)))
                (desc (or (cdr (assoc "DESCRIPTION" props)) "")))
            (when (and extends
                       (= level 0)          ; file-level nodes only
                       (not (equal id self))
                       (string-match-p (regexp-quote self) extends))
              (push (list id title desc) rows))))))
    (if (null rows)
        (insert "No policies extend this procedure.")
      (insert "| Policy | Description |\n|-+-|\n")
      (dolist (r (sort rows (lambda (a b) (string< (or (nth 1 a) "") (or (nth 1 b) "")))))
        (insert (format "| [[id:%s][%s]] | %s |\n" (nth 0 r) (nth 1 r) (nth 2 r))))
      (ignore-errors (forward-line -1) (org-table-align)))))

;; Register `policies' as an insertable dynamic block: C-c C-x x -> "policies"
(after! org
  (org-dynamic-block-define
   "policies"
   (lambda ()
     (org-create-dblock '(:name "policies"))
     (org-update-dblock))))

;; Display-width table alignment so org tables with links read straight (GUI)
(add-hook 'org-mode-hook #'valign-mode)
(setq valign-fancy-bar t)

;; --- Prose: soft-wrap, not hard newlines -------------------------------------
;; Notes store one logical line per paragraph and let the editor wrap visually
;; (see the "Note Authoring" policy). visual-line-mode wraps at the window edge
;; and makes motion/editing operate on visual lines.
(add-hook 'org-mode-hook #'visual-line-mode)

;; --- Auto-revert: keep buffers in sync with on-disk changes ------------------
;; External tools (formatters, git, scripts, AI agents) save files atomically:
;; write a temp file, then rename() it over the target. macOS GUI Emacs watches
;; files via kqueue, which follows the original inode — so the rename slips past
;; the watcher and the open buffer never learns the file changed. (Terminal
;; Emacs reverts on buffer-switch/focus, which masked the problem there.)
;;
;; `global-auto-revert-mode' also *polls* every `auto-revert-interval' seconds
;; (5 by default), and polling catches the rename the notifier misses. We keep
;; `auto-revert-avoid-polling' nil to guarantee that fallback. It's a
;; process-global mode, so one call covers every client of the daemon (GUI+TTY).
(setq auto-revert-avoid-polling nil          ; rely on polling to catch atomic saves
      auto-revert-verbose nil                ; don't echo "Reverting buffer..." each poll
      global-auto-revert-non-file-buffers t) ; also refresh Dired and similar buffers
(global-auto-revert-mode 1)

;; --- Templating: the policies block on every procedure, kept current ---------
;; The policies table is a dynamic block, so two things must happen for it to be
;; useful on every procedure: the block has to EXIST, and it has to be REFRESHED.
;; Both are automatic for files under the org-roam tree:
;;   * Saving a Procedure-tagged note ensures the slot exists and refreshes it.
;;   * `+my/org-roam-insert-policies-block' retrofits an existing note on demand.
;; Other kinds carry no block --- policies reach them through directory scope.
;; Direct authoring (by hand or agent) stays first-class --- the author just
;; reproduces the preamble skeleton; see the "Org File Authoring" procedure.

(defvar +my/org-roam-auto-insert-policies t
  "When non-nil, saving a procedure note inserts the :POLICIES: block if absent.
Set to nil to leave placement manual; the save hook then only refreshes blocks
that already exist.")

(defun +my/org-roam--procedure-file-p ()
  "Non-nil when the buffer's #+filetags include Procedure."
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^#\\+filetags:\\s-*\\(.+\\)$" nil t)
      (member "Procedure" (split-string (match-string 1) ":" t)))))

(defun +my/org-roam--ensure-policies-block ()
  "Insert a :POLICIES: drawer holding an empty `policies' dblock into the file
preamble if absent --- procedures only, just after the file-level :PROPERTIES:
drawer, or at point-min if there is none. Returns non-nil when it inserted one."
  (when (+my/org-roam--procedure-file-p)
    (save-excursion
      (goto-char (point-min))
      (unless (re-search-forward "^#\\+BEGIN: policies\\b" nil t)
        (goto-char (point-min))
        (let ((ins (point-min)))
          (when (looking-at-p "^:PROPERTIES:")
            (when (re-search-forward "^:END:[ \t]*\n" nil t)
              (setq ins (point))))
          (goto-char ins)
          (insert ":POLICIES:\n#+BEGIN: policies\n#+END:\n:END:\n"))
        t))))

(defun +my/org-roam--note-file-p ()
  "Non-nil if the current buffer is an org file under `org-roam-directory'."
  (and buffer-file-name
       (derived-mode-p 'org-mode)
       (bound-and-true-p org-roam-directory)
       (file-in-directory-p buffer-file-name
                            (expand-file-name org-roam-directory))))

(defun +my/org-roam-policies-maintain ()
  "On save of a roam note, optionally insert and then refresh the policies block.
Best-effort: a DB hiccup or missing org-roam can never block the save."
  (when (+my/org-roam--note-file-p)
    (when +my/org-roam-auto-insert-policies
      (ignore-errors (+my/org-roam--ensure-policies-block)))
    (when (fboundp 'org-roam-db-query)
      (ignore-errors (save-excursion (org-update-all-dblocks))))))

(defun +my/org-roam-insert-policies-block ()
  "Insert the :POLICIES: block into this note if absent, then refresh it.
Use to retrofit an existing note."
  (interactive)
  (+my/org-roam--ensure-policies-block)
  (when (fboundp 'org-roam-db-query)
    (save-excursion (org-update-all-dblocks))))

(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'+my/org-roam-policies-maintain nil t)))

;; org-roam prepends the :PROPERTIES:/:ID: drawer, so the head below lands
;; right after it. No :POLICIES: slot here --- the save hook adds it once a
;; note's filetags include Procedure.
;; ${title}.org matches the existing title-named files (not slugified).
(after! org-roam
  (setq org-roam-capture-templates
        '(("d" "default" plain "%?"
           :target (file+head
                    "${title}.org"
                    "#+title: ${title}\n#+filetags:\n")
           :unnarrowed t)
          ("p" "policy" plain "%?"
           :target (file+head
                    "Policies/${title}.org"
                    "#+title: ${title}\n#+filetags: :Policy:\n")
           :unnarrowed t))))

;; --- Additive property layers ------------------------------------------------
;; Composable templating: rather than one monolithic template per note kind, each
;; LAYER names a set of property keys, and a note stacks the layers it needs. The
;; keys are ensured in the node's property drawer (empty placeholder if absent,
;; never clobbering a filled value); a procedure also carries the :POLICIES: drawer.
;; `base' (a short DESCRIPTION + a TYPE) is on every note; richer kinds add layers.
(defconst +my/note-layers
  '((base     . ("DESCRIPTION" "TYPE"))                                ; every note
    (sidecar  . ("ROAM_REFS" "DOCUMENTS" "ACQUIRED" "SHA256" "AUTHOR")) ; wraps an external artifact
    (document . ("VERSION"))                                           ; a document specifically
    (product  . ("MANUFACTURER" "MPN"))                                ; systems, chassis, parts
    (policy   . ("EXTENDS")))                                          ; procedures it constrains
  "Property-key sets by layer; a note's drawer is the union of its stacked layers.")

(defun +my/note-layer-keys (layers)
  "Ordered, de-duplicated property keys for LAYERS. `base' is always included first."
  (let (keys)
    (dolist (l (cons 'base layers))
      (dolist (k (cdr (assq l +my/note-layers)))
        (unless (member k keys) (push k keys))))
    (nreverse keys)))

(defun +my/org-roam-apply-layers (layers)
  "Ensure the property keys for LAYERS exist on this note (empty if absent, never
clobbering a filled value), plus the :POLICIES: drawer. Additive and idempotent."
  (save-excursion
    (dolist (k (+my/note-layer-keys layers))
      (unless (org-entry-get (point-min) k)
        (org-entry-put (point-min) k "")))
    (+my/org-roam--ensure-policies-block)))

(defun +my/org-roam-scaffold ()
  "Stack property layers onto this note interactively (`base' is implicit), then
refresh its dynamic blocks. Scaffolds a new note or enriches an existing one."
  (interactive)
  (let ((layers (mapcar #'intern
                        (seq-remove
                         (lambda (s) (string= s ""))
                         (completing-read-multiple
                          "Layers (besides base): "
                          (mapcar (lambda (c) (symbol-name (car c)))
                                  (assq-delete-all 'base (copy-alist +my/note-layers)))
                          nil t)))))
    (+my/org-roam-apply-layers layers)
    (when (fboundp 'org-roam-db-query)
      (ignore-errors (save-excursion (org-update-all-dblocks))))))

;; --- tmux-style window management --------------------------------------------
;; Drive Emacs the way tmux drives a terminal, mapping tmux's three tiers onto
;; the three Emacs ones:
;;
;;   tmux pane    -> Emacs window (a split)        C-SPC  " % h j k l x z
;;   tmux window  -> tab-bar tab (a layout)        C-SPC  c n p & , 1..9
;;   tmux session -> Doom workspace (persp)        SPC TAB ... / gt gT  (persists)
;;
;; The prefix is C-SPC, mirroring `prefix C-Space' from ~/.config/tmux/tmux.conf.
;; It COEXISTS with Doom's SPC leader: bare SPC (evil normal/visual) is untouched;
;; C-SPC (control held) is a separate key. The only casualty is `set-mark-command'
;; on C-SPC, which evil's visual state (v/V/C-v) replaces.
;;
;; (macOS note: if Ctrl-Space ever stops reaching Emacs, it's System Settings >
;; Keyboard > Shortcuts > Input Sources stealing it. Your tmux already uses
;; C-Space in the terminal, so it's evidently free here too.)

;; tmux "windows": the native tab bar. Doom's :ui workspaces module hooks
;; `tab-bar-mode' so each workspace keeps and PERSISTS its own set of tabs --
;; each "session" carries its own "windows", exactly like tmux.
(setq tab-bar-show t                      ; always show the bar, like tmux's status line
      tab-bar-tab-hints t                 ; number tabs 1.. (tmux window numbers)
      ;; a new tab opens Dired of the current directory (like the splits), not *scratch*
      tab-bar-new-tab-choice (lambda () (dired-noselect default-directory))
      tab-bar-close-button-show nil       ; no mouse chrome; keep it text-clean for TTY
      tab-bar-new-button-show nil)
(tab-bar-mode 1)

;; tmux "pane" zoom: a real toggle. `doom/window-maximize-buffer' is one-way (it
;; calls `delete-other-windows' and tells you to `winner-undo'). tmux's `prefix z'
;; TOGGLES -- maximize, then restore the exact split layout. Stash the window
;; configuration per-frame on zoom-in; put it back on zoom-out.
(defun +tmux/toggle-zoom-window ()
  "Toggle a tmux-style zoom of the selected window.
First call maximizes it (hiding the other windows in this frame); the next call
restores the previous split layout exactly."
  (interactive)
  (if-let ((wconf (frame-parameter nil '+tmux-zoom-wconf)))
      (progn
        (set-frame-parameter nil '+tmux-zoom-wconf nil)
        (set-window-configuration wconf))
    (when (> (count-windows) 1)
      (set-frame-parameter nil '+tmux-zoom-wconf (current-window-configuration))
      (delete-other-windows))))

;; tmux-style splits open a fresh Dired of the current directory in the new pane
;; (the closest analog to tmux's "new shell in #{pane_current_path}") instead of
;; mirroring the current buffer. `dired-jump' lands point on the file you split
;; from, and falls back to `default-directory' in non-file buffers.
(defun +tmux/split-below-dired ()
  "Split below, focus the new window, and open Dired of the current directory."
  (interactive)
  (+evil/window-split-and-follow)
  (dired-jump))

(defun +tmux/split-right-dired ()
  "Split right, focus the new window, and open Dired of the current directory."
  (interactive)
  (+evil/window-vsplit-and-follow)
  (dired-jump))

;; The C-SPC prefix map. Getting Ctrl+Space to actually reach us took untangling
;; three layered things:
;;
;;  1. Event encoding. Pressing Ctrl+Space delivers `C-@' (NUL) -- on the TTY and
;;     on this macOS GUI build alike -- while the modifier-encoded `C-SPC'
;;     (?\C-\s) is a DISTINCT event. We bind BOTH so it fires either way.
;;  2. Precedence. Doom's own `:config default +bindings' binds C-SPC to
;;     completion (see modules/config/default/+evil-bindings.el), and `corfu-mode'
;;     binds it as well. Those live in Doom's OVERRIDE layer / minor-mode maps,
;;     which outrank plain evil state maps -- so binding into evil-*-state-map
;;     loses. We bind in that SAME override layer via `map!' with state
;;     selectors; config.el loads last, so we win.
;;  3. State. Cover normal/visual/insert/motion/emacs so it works everywhere --
;;     notably insert state, where `"' would otherwise just self-insert.
;;
;; Side effects: this reclaims C-SPC from completion-at-point (use TAB or the
;; auto-popup to complete) and C-@ from set-mark (evil's visual state replaces it).
(define-prefix-command '+tmux/leader-map)
(map! :nvime "C-@"   #'+tmux/leader-map
      :nvime "C-SPC" #'+tmux/leader-map)
;; Fallback for any genuinely non-evil buffer (the map! layer above is state-scoped).
(global-set-key (kbd "C-@")   '+tmux/leader-map)
(global-set-key (kbd "C-SPC") '+tmux/leader-map)

;; Last precedence hurdle: `corfu-mode' binds C-SPC as an EVIL-STATE binding
;; inside `corfu-mode-map' (Doom's "complete here" key). An evil-state binding in
;; a minor-mode map outranks the global evil state maps the `map!' above writes
;; into -- so in any corfu-active buffer (i.e. most of them) corfu kept winning,
;; even though it looked fixed in a scratch buffer where corfu was off. Override
;; C-SPC at corfu's own level. config.el loads after Doom's corfu config, so this
;; wins. (corfu only claims C-SPC, not C-@, but we cover both for symmetry.)
(after! corfu
  (map! :map corfu-mode-map
        :nvi "C-SPC" #'+tmux/leader-map
        :nvi "C-@"   #'+tmux/leader-map))
(map! :map +tmux/leader-map
      ;; panes == Emacs windows. Splits open Dired in the new pane (see the
      ;; +tmux/split-*-dired commands above) -- tmux's "new shell in cwd" analog.
      :desc "split below"   "\""      #'+tmux/split-below-dired
      :desc "split right"   "%"       #'+tmux/split-right-dired
      :desc "go left"       "h"       #'evil-window-left
      :desc "go down"       "j"       #'evil-window-down
      :desc "go up"         "k"       #'evil-window-up
      :desc "go right"      "l"       #'evil-window-right
      :desc "kill pane"     "x"       #'delete-window
      :desc "zoom pane"     "z"       #'+tmux/toggle-zoom-window
      ;; windows == tab-bar tabs
      :desc "new window"    "c"       #'tab-new
      :desc "next window"   "n"       #'tab-next
      :desc "prev window"   "p"       #'tab-previous
      :desc "next window"   "<right>" #'tab-next
      :desc "prev window"   "<left>"  #'tab-previous
      :desc "kill window"   "&"       #'tab-close
      :desc "rename window" ","       #'tab-rename)

;; Select window (tab) N by number, tmux's `prefix 1..9'.
(dotimes (i 9)
  (let ((n (1+ i)))
    (define-key +tmux/leader-map (kbd (number-to-string n))
                (lambda () (interactive) (tab-bar-select-tab n)))))

;; Label the prefix as "tmux" in which-key, not the raw command name.
(after! which-key
  (which-key-add-key-based-replacements "C-SPC" "tmux"))

;; Cmd-W (super-w): kill the current buffer AND close its enclosing space, like a
;; real macOS close. Doom maps s-w to a window-close (`delete-window', itself
;; remapped to `+workspace/close-window-or-workspace'); binding s-w to our own
;; command bypasses that remap. We close in nesting order -- pane, then tab, then
;; workspace -- because `+workspace/close-window-or-workspace' alone is unaware of
;; native `tab-bar' tabs: on a single-pane tab it would skip to closing the
;; workspace and error ("Can't delete last workspace") instead of closing the tab.
;; Cover evil states + global so it applies everywhere.
(defun +my/kill-buffer-and-close-pane ()
  "Kill the current buffer, then close its enclosing space: pane, else tab,
else workspace. If the tab has multiple panes, close just this pane; else if
there are multiple tabs, close this tab; else if there are multiple workspaces,
close this workspace; else leave the window. Aborts if killing is declined."
  (interactive)
  (when (kill-buffer (current-buffer))
    (cond ((> (count-windows) 1)         (delete-window))
          ((cdr (tab-bar-tabs))          (tab-close))
          ((cdr (+workspace-list-names)) (+workspace/close-window-or-workspace)))))
(map! :nvime "s-w" #'+my/kill-buffer-and-close-pane)
(global-set-key (kbd "s-w") #'+my/kill-buffer-and-close-pane)

;; --- project sidebar (Treemacs) -----------------------------------------------
;; Not to be confused with the Dired that the tmux-style splits/tabs above open
;; in the new pane (tmux's "new shell in cwd" analog -- workspace-blind by
;; design). The workspace-aware directory browser is Treemacs: `SPC o p'
;; toggles a LEFT side window whose project list is scoped to the current Doom
;; workspace (treemacs-persp, 'Perspectives scope). Project-follow keeps the
;; tree pointed at the project of the buffer you're in; Doom leaves the more
;; jarring cursor-level `treemacs-follow-mode' off, and we agree.
(after! treemacs
  (treemacs-project-follow-mode +1))

;; Start the Emacs server so `emacsclient' (and agent tooling) can reach and
;; inspect the running session.
(require 'server)
(unless (server-running-p)
  (server-start))

;; Keep internal/autosave files out of the recent-files list (dashboard,
;; consult-buffer). The offender is Doom's persp session autosave under
;; `doom-local-dir' (Doom's own recentf-exclude doesn't cover its local dir);
;; also drop Emacs auto-save (#name#) and lock (.#name) files.
(after! recentf
  (add-to-list 'recentf-exclude
               (lambda (f) (file-in-directory-p f doom-local-dir)))
  (add-to-list 'recentf-exclude "/#[^/]*#\\'")  ; auto-save files
  (add-to-list 'recentf-exclude "/\\.#"))         ; lock files

;; nvim parity: mirror the file keys from ~/.config/nvim (leader is SPC in both).
;;   SPC p v -> Dired (file browser)   == nvim <leader>pv (:Ex / netrw)
;;   SPC p f -> projectile-find-file   == nvim <leader>pf (Telescope find_files)
;; SPC p f is already Doom's project file finder; binding it explicitly just
;; documents the parity. (dired-jump also lives on SPC o - and C-x C-j.)
(map! :leader
      :desc "Browse files (dired)" "p v" #'dired-jump
      :desc "Find file in project" "p f" #'projectile-find-file)

;; --- Treemacs: directory sidebar on the left, tied to the active buffer ------
;; SPC o p toggles the tree; SPC o P reveals the current file in it.
;; follow-mode keeps the active buffer's file selected in the tree, and
;; project-follow-mode retargets the tree when the buffer's project changes,
;; so the sidebar always shows where you are. Single left click expands a
;; directory or opens a file, browser-style (default is double-click).
(after! treemacs
  (treemacs-follow-mode 1)
  (treemacs-project-follow-mode 1)
  (setq treemacs-width 32
        treemacs-width-is-initially-locked nil) ; allow mouse-drag resizing
  (define-key treemacs-mode-map [mouse-1]
              #'treemacs-single-click-expand-action))

;; A grabbable divider between windows, so the sidebar resizes by mouse drag.
;; Doom's default right divider is 1 px — nearly impossible to hit; drags land
;; on the fringe instead (<left-fringe> <drag-mouse-1> is undefined).
(setq window-divider-default-right-width 5)

;; --- Grammar: langtool via the Homebrew CLI, not a jar path ------------------
(after! langtool
  (setq langtool-bin "/opt/homebrew/bin/languagetool"))

;; --- Treemacs: auto-open the sidebar in GUI frames ---------------------------
;; Treemacs is toggle-based and never appears on its own; this shows it in every
;; graphical frame without stealing focus. Per-frame like the theme above,
;; because the daemon evaluates this file with no display attached.
(defun +my/treemacs-for-frame (&optional frame)
  "Open the treemacs sidebar in graphical FRAME without stealing focus."
  (let ((f (or frame (selected-frame))))
    (when (display-graphic-p f)
      (run-with-idle-timer
       0.2 nil
       (lambda ()
         (when (frame-live-p f)
           (with-selected-frame f
             (save-selected-window
               (treemacs-select-window)))))))))
(add-hook 'after-make-frame-functions #'+my/treemacs-for-frame)
(add-hook 'server-after-make-frame-hook #'+my/treemacs-for-frame)
(unless (daemonp) (add-hook 'window-setup-hook #'+my/treemacs-for-frame))
