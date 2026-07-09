# Cluster CLIs: keep config out of ~ (per-workspace .envrc still
# overrides these globals via direnv).

# kubectl — config file + discovery cache (KUBECACHEDIR works even
# though `kubectl options` doesn't list it)
export KUBECONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/kube/config"
export KUBECACHEDIR="${XDG_CACHE_HOME:-$HOME/.cache}/kube"

# talosctl — config file (local-cluster state under ~/.talos/clusters
# has no env var and is left in place)
export TALOSCONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/talos/config"
