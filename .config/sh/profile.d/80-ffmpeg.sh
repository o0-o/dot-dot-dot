# guile
[ -e '/usr/local/share/guile/site/3.0'      ]                             &&
export GUILE_LOAD_PATH='/usr/local/share/guile/site/3.0'

[ -e '/usr/local/lib/guile/3.0/site-ccache' ]                             &&
export GUILE_LOAD_COMPILED_PATH='/usr/local/lib/guile/3.0/site-ccache'

[ -e '/usr/local/lib/guile/3.0/extensions'  ]                             &&
export GUILE_SYSTEM_EXTENSIONS_PATH='/usr/local/lib/guile/3.0/extensions'

[ -e '/usr/local/etc/gnutls/'               ]                             &&
export GUILE_TLS_CERTIFICATE_DIRECTORY='/usr/local/etc/gnutls/'

# icu4c
[ -e "/usr/local/opt/icu4c/bin:$PATH"     ]                 &&
export PATH="/usr/local/opt/icu4c/bin:$PATH"

[ -e "/usr/local/opt/icu4c/sbin:$PATH"    ]                 &&
export PATH="/usr/local/opt/icu4c/sbin:$PATH"

[ -e '/usr/local/opt/icu4c/lib'           ]                 &&
export LDFLAGS='-L/usr/local/opt/icu4c/lib'

[ -e '/usr/local/opt/icu4c/include'       ]                 &&
export CPPFLAGS='-I/usr/local/opt/icu4c/include'

[ -e '/usr/local/opt/icu4c/lib/pkgconfig' ]                 &&
export PKG_CONFIG_PATH='/usr/local/opt/icu4c/lib/pkgconfig'
