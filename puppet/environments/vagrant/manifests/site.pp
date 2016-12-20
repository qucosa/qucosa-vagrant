# Defining stages used by this manifest
stage { 'pre-main':
    before => Stage['main']
}

stage { 'post-main':
    require => Stage['main']
}

# Default path for exec resource
Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

hiera_include('classes')
