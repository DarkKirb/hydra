setup *OPTIONS:
  meson setup build --prefix="$PWD/outputs/out" $mesonFlags {{ OPTIONS }}

build *OPTIONS:
  meson compile -C build {{ OPTIONS }}

install *OPTIONS: (build OPTIONS)
    meson install -C build

test *OPTIONS:
    meson test -C build --print-errorlogs {{ OPTIONS }}
