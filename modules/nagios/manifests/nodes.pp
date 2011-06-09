class nagios::nodes {

    @@nagios_host {
        $fqdn:
        ensure => present,
        alias => $hostname,
        address => $ipaddress,
        use => "linux-server",
        hostgroups => "$hostgroups",
    }
    
    define part_check {
        @@nagios_service {
            "check_disk_${hostname}_$name":
                use => 'generic-service',
                service_description => "$name",
                check_command => "check_nrpe!disk_$name",
                notify => Service['nagios'],
                require => Package['nagios'],
                host_name => "$fqdn",
                servicegroups => 'disks',
        }
    }

    file {
        'facter_disks':
            path => "$rubysitedir/facter/disks.rb",
            ensure => present,
            source => 'puppet:///modules/nagios/disks.rb',
            require => Service["nrpe"],
    }

    if ($disks){
        file {
                '/etc/nagios/nrpe.cfg':
                content => template('nagios/nrpe.cfg.erb'),
                ensure => present,
                require => Package['nrpe'],
                notify => Service['nrpe'],
        }
        
        $array_of_disks = split($disks, ',')
        part_check { $array_of_disks: }
    }

}
