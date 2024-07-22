# Native code
subdir('libhydra')
subdir('hydra-evaluator')
subdir('hydra-queue-runner')

# Data and interpreted
foreach dir : ['lib', 'root', 'sql', 'ttf']
  install_subdir(dir,
    install_dir: get_option('libexecdir') / 'hydra',
  )
endforeach
install_subdir('script',
  install_dir: get_option('bindir'),
  install_mode: 'rwxr-xr-x',
  strip_directory: true,
)
