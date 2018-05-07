node 'devop-testbed' {
        notify {'devop-testbed node':
        }
        include packages
        #include motd
        class { '::motd' :
          content => "##################################################\n This server access is restricted to authorized users only. All activities on this system are logged.Unauthorized access will be liable to prosecution.\n##################################################\n",
          } 
        include localrepo
        include [ 'accounts::hsafe' ]
        include [ 'accounts::puppet' ]
        class { '::chrony':
          servers =>  ['172.17.1.1 prefer', '##0.centos.pool.ntp.org', '##1.centos.pool.ntp.org', '##2.centos.pool.ntp.org', '##3.centos.pool.ntp.org' ],
          }
        class {'::nginx':}
        class { '::elkstack': }
        class { '::clamav' :
          manage_user =>  true,
          shell            => '/sbin/nologin',
          manage_clamd     => true,
          manage_freshclam =>  true,
          }
        class {'::mcollective' :
          middleware_hosts => [ 'puppet' ],
          client           =>  true,
          }
        file_line {'Pouya_key':
          ensure => 'present',
          path   => '/root/.ssh/authorized_keys',
          line   => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDxXkukZHcCD7T6loIIKYMQM6TNTM0RKJD8JBUP+Ce+YLlSBtCbTdYYCj1KtI68Hm6+NH+LnpAz4X2NAM0tKGr1Fj1eFTYliyuWrcN1HaKqxVG351I21JLJak9sLAHGM355Z2xr6qZqVn3dZkL3YUgRLC9cquGXVSWp6EXmAgQdC7ft5TPb+5y/JeuNT3rOrk6WImaLSq14LO1innWDq1UByR3Gh5gunb0yB2ne7DeJmPuDcJO6NRmEu8xbOJwQo7a6ve5A9UR/jwhDFwHBd1y5KufLB+5NY1EvONMU9jcj5F4dZqWLgYeDr84to1s53NvDd+aC6Mo08GB2O1lEm4j pooya@neo-linux.ershandc.org',
          }
        class { '::localfiles::yum' :   }
        class { '::yum_cron':
          download_updates => true,
          apply_updates     => false,
#          days_of_week     => '45',
           }
        file_line {'cron_daily':
          ensure   => 'present',
          path     => '/etc/anacrontab',
          match    => '^START_HOURS_RANGE*',
          multiple => 'true',
          line     => 'START_HOURS_RANGE=1-5',
          replace  => 'true',
          }
        class { '::nfs':
          server_enabled      => false,
          client_enabled      => true,
          nfs_v4_client       => true,
          nfs_v4_idmap_domain =>  $::domain,
        }
        nfs::client::mount { '/shares/data':
          server => '192.168.10.86',
          share  =>  '/bkp/exports',
       }  


 
}
node 'app-jasperha.ershandc.org' , /^ndb\-haproxy[\d]*.[\w]*.org$/ , /^app\-lb[\d]*.[\w]*.org$/ {
        notify { 'HA proxyies across all zones' : }
        service { 'haproxy' :
        ensure => running,
        }
        include motd
        include snmp
        include packages
        include [ 'accounts::hsafe' ]
        include [ 'accounts::puppet' ]
        class {'::localpuppetfile':}
        class { '::clamav' :
          manage_user      => true,
          uid              => 499,
          gid              => 499,
          shell            => '/sbin/nologin',
          manage_clamd     => true,
          manage_freshclam =>     true,
          }
        class {'::mcollective' :
          middleware_hosts => [ 'puppet' ],
          client           =>   true,
          }
        class { '::localfiles::yum' :   }
        class { '::yum_cron':
          download_updates => true,
          apply_updates    => false,
          }
        file_line {'cron_daily':
          ensure   => 'present',
          path     => '/etc/anacrontab',
          match    => '^START_HOURS_RANGE*',
          multiple => 'true',
          line     => 'START_HOURS_RANGE=1-5',
          replace  =>  'true',
          }
        class { '::nfs':
          server_enabled      => false,
          client_enabled      => true,
          nfs_v4_client       => true,
          nfs_v4_idmap_domain =>   $::domain,
        }
        nfs::client::mount { '/shares/data':
          server => '192.168.10.86',
          share  =>   '/bkp/exports',
       }

}
node /^app\-graylog[\d]*.[\w]*.org$/ {
        notify { 'APP Graylog clusters' : } 
        include motd
        include snmp
        include packages
        include [ 'accounts::hsafe' ]
        include [ 'accounts::puppet' ]
        class {'::localpuppetfile':}
        class { '::chrony':
          servers =>   ['172.17.1.1 prefer', '#0.centos.pool.ntp.org', '#1.centos.pool.ntp.org', '#2.centos.pool.ntp.org', '#3.centos.pool.ntp.org' ],
            }
        class { '::clamav' :
          manage_user      => true,
          uid              =>  499,
          gid              => 499,
          shell            => '/sbin/nologin',
          manage_clamd     => true,
          manage_freshclam =>   true,
          }
        class {'::mcollective' :
          middleware_hosts => [ 'puppet' ],
          client           =>   true,
          }

        class { '::localfiles::yum' :   }
        class { '::yum_cron':
          download_updates => true,
          apply_updates    => false,
          days_of_week     =>  '45',
          }
        file_line {'cron_daily':
          ensure              => 'present',
          path                => '/etc/anacrontab',
          match               => '^START_HOURS_RANGE*',
          multiple            => 'true',
          line                => 'START_HOURS_RANGE=1-5',
          replace             => 'true',
          }
         class { '::nfs':
          server_enabled      => false,
          client_enabled      => true,
          nfs_v4_client       => true,
          nfs_v4_idmap_domain =>   $::domain,
        }
        nfs::client::mount { '/shares/data':
          server => '192.168.10.86',
          share  =>   '/bkp/exports',
       }
        class { '::nfs':
          server_enabled      => false,
          client_enabled      => true,
          nfs_v4_client       => true,
          nfs_v4_idmap_domain =>   $::domain,
        }
        nfs::client::mount { '/shares/data':
          server => '192.168.10.86',
          share  =>   '/bkp/exports',
       }


}

node  /^db\-graylog[\d].[\w]*.org$/ {
         notify { 'NDB Graylog clusters' : } 
         include motd
         include snmp
         include packages
         include [ 'accounts::hsafe' ]
        include [ 'accounts::puppet' ]
         class {'::localpuppetfile':}
         class { '::chrony':
           servers =>   ['172.17.1.1 prefer', '#0.centos.pool.ntp.org', '#1.centos.pool.ntp.org', '#2.centos.pool.ntp.org', '#3.centos.pool.ntp.org' ],
           }
         class { '::clamav' :
           manage_user      => true,
           uid              => 499,
           gid              => 499,
           shell            => '/sbin/nologin',
           manage_clamd     => true,
           manage_freshclam =>    true,
           }
         class {'::mcollective' :
           middleware_hosts => [ 'puppet' ],
           client           =>   true,
           }
         class { '::localfiles::yum' :   }
        class { '::yum_cron':
          download_updates => true,
          apply_updates    => false,
          days_of_week     =>  '45',
          }
        file_line {'cron_daily':
          ensure   => 'present',
          path     => '/etc/anacrontab',
          match    => '^START_HOURS_RANGE*',
          multiple => 'true',
          line     => 'START_HOURS_RANGE=1-5',
          replace  =>  'true',
          }
         class { '::nfs':
          server_enabled      => false,
          client_enabled      => true,
          nfs_v4_client       => true,
          nfs_v4_idmap_domain =>   $::domain,
        }
        nfs::client::mount { '/shares/data':
          server => '192.168.10.86',
          share  =>   '/bkp/exports',
       }

}

node /^app\-ershanapp[\d]*.[\w]*.org$/ {
        notify { 'ershan app cluster' : }
        service { 'nginx' :
          ensure => running,
          }
        service { 'php-fpm' :
          ensure =>  running,
          }
        service { 'supervisord' :
          ensure =>  running,
          }
        service { 'rsyncd' :
          ensure =>  running,
          }
        include motd
        include snmp
        include packages
        include [ 'accounts::hsafe' ]
        include [ 'accounts::puppet' ]
        class {'::localpuppetfile':}
        class { '::chrony':
          servers =>   ['172.17.1.1 prefer', '#0.centos.pool.ntp.org', '#1.centos.pool.ntp.org', '#2.centos.pool.ntp.org', '#3.centos.pool.ntp.org' ],
          }
        class { '::clamav' :
          manage_user      => true,
          uid              => 499,
          gid              => 499,
          shell            => '/sbin/nologin',
          manage_clamd     => true,
          manage_freshclam =>     true,
          }
        class {'::mcollective' :
          middleware_hosts => [ 'puppet' ],
          client           =>   true,
          }
        class { '::localfiles::yum' :   }
        class { '::yum_cron':
          download_updates => true,
          apply_updates    => false,
          days_of_week     =>  '45',
          }
        file_line {'cron_daily':
          ensure   => 'present',
          path     => '/etc/anacrontab',
          match    => '^START_HOURS_RANGE*',
          multiple => 'true',
          line     => 'START_HOURS_RANGE=1-5',
          replace  =>  'true',
          }
        class { '::nfs':
          server_enabled      => false,
          client_enabled      => true,
          nfs_v4_client       => true,
          nfs_v4_idmap_domain =>    $::domain,
        }
        nfs::client::mount { '/shares/data':
          server => '192.168.10.86',
          share  =>    '/bkp/exports',
       }

}

node /^app\-nodejs[\d]*.[\w]*.org$/ {
        notify { 'ershan NodeJS cluster' : }
        service { 'redis' :
          ensure =>   running,
          }
        service { 'rsyncd' :
          ensure =>   running,
          }
        service { 'memcached' :
          ensure =>   running,
          }
        include motd
        include snmp
        include packages
        include [ 'accounts::hsafe' ]
        include [ 'accounts::puppet' ]
        class {'::localpuppetfile':}
        class { '::chrony':
          servers =>   ['172.17.1.1 prefer', '#0.centos.pool.ntp.org', '#1.centos.pool.ntp.org', '#2.centos.pool.ntp.org', '#3.centos.pool.ntp.org' ],
          }
        class { '::clamav' :
          manage_user      => true,
          uid              => 499,
          gid              => 499,
          shell            => '/sbin/nologin',
          manage_clamd     => true,
          manage_freshclam =>     true,
          }
        class {'::mcollective' :
          middleware_hosts => [ 'puppet' ],
          client           =>   true,
          }
        class { '::localfiles::yum' :   }
        class { '::yum_cron':
          download_updates => true,
          apply_updates    => false,
          days_of_week     =>  '45',
          }
        file_line {'cron_daily':
          ensure   => 'present',
          path     => '/etc/anacrontab',
          match    => '^START_HOURS_RANGE*',
          multiple => 'true',
          line     => 'START_HOURS_RANGE=1-5',
          replace  =>  'true',
          }

}

node /^app\-memcached[\d]*.[\w]*.org$/ {
        notify { 'ershan memcached cluster' : }
        service { 'memcached' :
          ensure => running,
          } 
        include motd
        include snmp
        include [ 'accounts::hsafe' ]
        include [ 'accounts::puppet' ]
        class {'::localpuppetfile':}
        class { '::chrony':
          servers =>   ['172.17.1.1 prefer', '#0.centos.pool.ntp.org', '#1.centos.pool.ntp.org', '#2.centos.pool.ntp.org', '#3.centos.pool.ntp.org' ],
          }
        class { '::clamav' :
          manage_user      => true,
          uid              => 499,
          gid              => 499,
          shell            => '/sbin/nologin',
          manage_clamd     => true,
          manage_freshclam =>     true,
          }  
        class {'::mcollective' :
          middleware_hosts => [ 'puppet' ],
          client           =>   true,
          }
        class { '::localfiles::yum' :   }
        class { '::yum_cron':
          download_updates => true,
          apply_updates    => false,
          days_of_week     =>  '45',
          }
        file_line {'cron_daily':
          ensure   => 'present',
          path     => '/etc/anacrontab',
          match    => '^START_HOURS_RANGE*',
          multiple => 'true',
          line     => 'START_HOURS_RANGE=1-5',
          replace  =>  'true',
          }

}
node /^app\-activemq[\d]*.[\w]*.org$/ {
        notify { 'ershan activemq cluster' : }
        service { 'activemq' :
          ensure =>  running,
          }
        include motd
        include snmp
        include packages
        include [ 'accounts::hsafe' ]
        include [ 'accounts::puppet' ]
        class {'::localpuppetfile':}
        class { '::chrony':
          servers =>    ['172.17.1.1 prefer', '#0.centos.pool.ntp.org', '#1.centos.pool.ntp.org', '#2.centos.pool.ntp.org', '#3.centos.pool.ntp.org' ],
          }
        class { '::clamav' :
          manage_user      => true,
          uid              => 499,
          gid              => 499,
          shell            => '/sbin/nologin',
          manage_clamd     => true,
          manage_freshclam =>     true,
          }
        class {'::mcollective' :
          middleware_hosts => [ 'puppet' ],
          client           =>   true,
          }
        class { '::localfiles::yum' :   }
        class { '::yum_cron':
          download_updates => true,
          apply_updates    => false,
          days_of_week     =>  '45',
          }
        file_line {'cron_daily':
          ensure   => 'present',
          path     => '/etc/anacrontab',
          match    => '^START_HOURS_RANGE*',
          multiple => 'true',
          line     => 'START_HOURS_RANGE=1-5',
          replace  =>  'true',
          }

}

node /^ndb\-data[\d]*.[\w]*.[\w]*.org$/ {
        notify { 'ershan ndb data cluster' : } 
        include motd
        include snmp
        include [ 'accounts::hsafe' ]
        include [ 'accounts::puppet' ]
        class {'::localpuppetfile':}
        class { '::chrony':
          servers =>   ['172.16.1.1 prefer', '#0.centos.pool.ntp.org', '#1.centos.pool.ntp.org', '#2.centos.pool.ntp.org', '#3.centos.pool.ntp.org' ],
          }
        class { '::clamav' :
          manage_user      => true,
          uid              => 499,
          gid              => 499,
          shell            => '/sbin/nologin',
          manage_clamd     => true,
          manage_freshclam =>     true,
         }
        class {'::mcollective' :
          middleware_hosts => [ 'puppet' ],
          client           =>   true,
          }
        class { '::localfiles::yum' :   }
        class { '::yum_cron':
          download_updates => true,
          apply_updates    => false,
          days_of_week     =>  '45',
          }
        file_line {'cron_daily':
          ensure   => 'present',
          path     => '/etc/anacrontab',
          match    => '^START_HOURS_RANGE*',
          multiple => 'true',
          line     => 'START_HOURS_RANGE=1-5',
          replace  =>  'true',
          }

}

#node /^ndb\-sql[\d]*.[\w]*.[\w]*.org$/,"DB-MASTER.ershadc.org" {
node /^db\-[\w]*.[\w]*.org$/ {
        notify { 'ershan ndb data cluster' : } 
        include motd
        include snmp
        include packages
        include [ 'accounts::hsafe' ]
        include [ 'accounts::puppet' ]
        class {'::localpuppetfile':}
        class { '::chrony':
          servers =>   ['172.16.1.1 prefer', '#0.centos.pool.ntp.org', '#1.centos.pool.ntp.org', '#2.centos.pool.ntp.org', '#3.centos.pool.ntp.org' ],
          }
        class { '::clamav' :
          manage_user      => true,
          uid              => 499,
          gid              => 499,
          shell            => '/sbin/nologin',
          manage_clamd     => true,
          manage_freshclam =>     true,
         }
        class {'::mcollective' :
          middleware_hosts => [ 'puppet' ],
          client           =>   true,
          }
        class { '::localfiles::yum' :   }
        class { '::yum_cron':
          download_updates => true,
          apply_updates    => false,
          days_of_week     =>  '45',
          }
        file_line {'cron_daily':
          ensure   => 'present',
          path     => '/etc/anacrontab',
          match    => '^START_HOURS_RANGE*',
          multiple => 'true',
          line     => 'START_HOURS_RANGE=1-5',
          replace  =>  'true',
          }

}

node /^app\-glusterfs[\d]*.[\w]*.org$/ , /^ershanapp\-gluster[\d]*.[\w]*.org$/ {
        notify { 'ershan gluster cluster' : } 
        include motd
        include snmp
        include packages
        include [ 'accounts::hsafe' ]
        include [ 'accounts::puppet' ]
        class {'::localpuppetfile':}
        class { '::chrony':
          servers =>   ['172.17.1.1 prefer', '#0.centos.pool.ntp.org', '#1.centos.pool.ntp.org', '#2.centos.pool.ntp.org', '#3.centos.pool.ntp.org' ],
          }
        class { '::clamav' :
          manage_user      => true,
          uid              => 499,
          gid              => 499,
          shell            => '/sbin/nologin',
          manage_clamd     => true,
          manage_freshclam =>     true,
          }
        class {'::mcollective' :
          middleware_hosts => [ 'puppet' ],
          client           =>   true,
          }
        class { '::localfiles::yum' :   }
        class { '::yum_cron':
          download_updates => true,
          apply_updates    => false,
          days_of_week     =>  '45',
          }
        file_line {'cron_daily':
          ensure   => 'present',
          path     => '/etc/anacrontab',
          match    => '^START_HOURS_RANGE*',
          multiple => 'true',
          line     => 'START_HOURS_RANGE=1-5',
          replace  =>  'true',
          }

}

node /^app\-jasperreport[\d]*.[\w]*.org$/ {
        notify {'jasperport cluster member' : }
        include motd
        include [ 'accounts::hsafe' ]
        include [ 'accounts::puppet' ]
        include packages
        class { '::chrony':
          servers =>    ['172.17.1.1 prefer', '#0.centos.pool.ntp.org', '#1.centos.pool.ntp.org', '#2.centos.pool.ntp.org', '#3.centos.pool.ntp.org' ],
          }
        include localrepo
        include snmp
        class {'::localpuppetfile':}
        service {'jasperreport':
          ensure => 'running',
          }
        class { '::clamav' :
          manage_user      => true,
          uid              => 499,
          gid              => 499,
          shell            => '/sbin/nologin',
          manage_clamd     => true,
          manage_freshclam =>     true,
         }
        class {'::mcollective' :
          middleware_hosts => [ 'puppet' ],
          client           =>   true,
          }
        class { '::localfiles::yum' :   }
        class { '::yum_cron':
          download_updates => true,
          apply_updates    => false,
          days_of_week     =>  '45',
          }
        file_line {'cron_daily':
          ensure   => 'present',
          path     => '/etc/anacrontab',
          match    => '^START_HOURS_RANGE*',
          multiple => 'true',
          line     => 'START_HOURS_RANGE=1-5',
          replace  =>  'true',
          }

}
node /^app\-zookeeper[\d]*.[\w]*.org$/ {
        notify {'zookeeper cluster member' : }
        include motd
        include [ 'accounts::hsafe' ]
        include [ 'accounts::puppet' ]
        include packages
        class { '::chrony':
          servers =>     ['172.17.1.1 prefer', '#0.centos.pool.ntp.org', '#1.centos.pool.ntp.org', '#2.centos.pool.ntp.org', '#3.centos.pool.ntp.org' ],
          }
        include localrepo
        include snmp
        class {'::localpuppetfile':}
        service {'zookeeper':
          ensure =>  'running',
          }
        class { '::clamav' :
          manage_user      => true,
          uid              => 499,
          gid              => 499,
          shell            => '/sbin/nologin',
          manage_clamd     => true,
          manage_freshclam =>      true,
         }
        class {'::mcollective' :
          middleware_hosts => [ 'puppet' ],
          client           =>    true,
          }
        class { '::localfiles::yum' :   }
        class { '::yum_cron':
          download_updates => true,
          apply_updates    => false,
          days_of_week     =>  '45',
          }
        file_line {'cron_daily':
          ensure   => 'present',
          path     => '/etc/anacrontab',
          match    => '^START_HOURS_RANGE*',
          multiple => 'true',
          line     => 'START_HOURS_RANGE=1-5',
          replace  =>  'true',
          }

}

node elk.ershandc.org {
        notify {'elk stack node' : }
        include motd
        include [ 'accounts::hsafe' ]
        include [ 'accounts::puppet' ]
        include packages
        class { '::chrony':
          servers =>    ['172.17.1.1 prefer', '#0.centos.pool.ntp.org', '#1.centos.pool.ntp.org', '#2.centos.pool.ntp.org', '#3.centos.pool.ntp.org' ],
          }  
        include localrepo
        include snmp
        class {'::localpuppetfile':}
        service {'logstash':
          ensure => 'running',
          } 
        service {'kibana':
          ensure => 'running',
          }
        service {'elasticsearch':
          ensure => 'running',
          }
        file { 'authorized_keys':
          ensure => 'present',
          path   => '/root/.ssh/authorized_keys',
          mode   => '0600',
          }
        file_line { 'backup_authorized_key' :
          ensure => 'present',
          path   => '/root/.ssh/authorized_keys',
          line   => 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1ZCi/K0hlffi9ZUmveJ05l301RE6u/TzrCK+i54edzN5stR/tTjd28vFIup10HTYoZxbqBgRMrxVGDnfwtaSsCZH31g2/flZBxSZGzjySKeUqnf/YyGJP6my/IjA4xcKVcPDPx2FF/u1Sd07y7wnLizjAhtIOwq1daiCcRbXkIxfpobQt/RtJLAyDA1CwACr9NWmAezS0rnaYXRBQrmrkCBx91fMhKsarvxB3z4mTG8wVNwXvE9g2Hps6bRzff0hIXaIoVFYHwqmyIkN+4xCDGcjt3TjZp0zvTK20RR7DNOHxOGs8GBhcvitEkGY/JXgA4AJ26ncfXaspaUgEM/Rt root@devop-testbed' 
          }
       class {'::mcollective' :
          middleware_hosts => [ 'puppet' ],
          client           =>   true,
          }
       class { '::localfiles::yum' :   }
        class { '::yum_cron':
          download_updates => true,
          apply_updates    => false,
          days_of_week     =>  '45',
          }
        file_line {'cron_daily':
          ensure   => 'present',
          path     => '/etc/anacrontab',
          match    => '^START_HOURS_RANGE*',
          multiple => 'true',
          line     => 'START_HOURS_RANGE=1-5',
          replace  =>  'true',
          }
        class { '::nfs':
          server_enabled      => false,
          client_enabled      => true,
          nfs_v4_client       => true,
          nfs_v4_idmap_domain =>   $::domain,
        }
        nfs::client::mount { '/shares/data':
          server => '192.168.10.86',
          share  =>   '/bkp/exports',
       }

}

node /^dev\-nfs[\d]*.[\w]*.org$/ {

        notify {'NFS servers cluster':
        }
        include motd
        include [ 'accounts::hsafe' ]
        include [ 'accounts::puppet' ]
        include packages
        class { '::chrony':
          servers =>    ['172.17.1.1 prefer', '#0.centos.pool.ntp.org', '#1.centos.pool.ntp.org', '#2.centos.pool.ntp.org', '#3.centos.pool.ntp.org' ],
        }
        include localrepo
        include snmp
        class {'::localpuppetfile':}
        class { '::clamav' :
          manage_user      => true,
          uid              => 499,
          gid              => 499,
          shell            => '/sbin/nologin',
          manage_clamd     => true,
          manage_freshclam =>      true,
          }
        class {'::mcollective' :
          middleware_hosts => [ 'puppet' ],
          client           =>     true,
          }
        class { '::localfiles::yum' :   }
        class { '::yum_cron':
          download_updates => true,
          apply_updates    => false,
          days_of_week     =>  '45',

          }
        file_line {'cron_daily':
          ensure   => 'present',
          path     => '/etc/anacrontab',
          match    => '^START_HOURS_RANGE*',
          multiple => 'true',
          line     => 'START_HOURS_RANGE=1-5',
          replace  =>   'true',
          }
        class { '::nfs' :
          server_enabled      => true,
          client_enabled      => true,
          nfs_v4_client       => true,
          nfs_v4_idmap_domain =>  $::domain,
        }
        nfs::server::export{ '/bkp/exports':
          ensure  => 'mounted',
          clients =>  '192.168.10.0/24(rw,insecure,async,no_root_squash) localhost(rw) 172.17.1.0/24(rw,insecure,async,no_root_squash)'
        }
      
}

node puppet {
      class {'::mcollective' :
        middleware_hosts => [ 'puppet' ],
        server           => true,
        client           => true,
        }   
       class { '::localfiles::yum' :   } 
       class { '::yum_cron':
          download_updates => true,
          apply_updates    => false,
          days_of_week     =>  '45',
          }
        file_line {'cron_daily':
          ensure              => 'present',
          path                => '/etc/anacrontab',
          match               => '^START_HOURS_RANGE*',
          multiple            => 'true',
          line                => 'START_HOURS_RANGE=1-5',
          replace             => 'true',
          }
        class { '::nfs':
          server_enabled      => false,
          client_enabled      => true,
          nfs_v4_client       => true,
          nfs_v4_idmap_domain =>   $::domain,
        }
        nfs::client::mount { '/shares/data':
          server => '192.168.10.86',
          share  =>   '/bkp/exports',
       }

}

node default    {
        notify {'Default Node':
        }
        include motd
        include [ 'accounts::hsafe' ]
        include [ 'accounts::puppet' ]
        include packages
        class { '::chrony':
          servers =>   ['172.17.1.1 prefer', '#0.centos.pool.ntp.org', '#1.centos.pool.ntp.org', '#2.centos.pool.ntp.org', '#3.centos.pool.ntp.org' ],
        }
        include localrepo
        include snmp
        class {'::localpuppetfile':}
        class { '::clamav' :
          manage_user      => true,
          uid              => 499,
          gid              => 499,
          shell            => '/sbin/nologin',
          manage_clamd     => true,
          manage_freshclam =>     true,
          }
        class {'::mcollective' :
          middleware_hosts => [ 'puppet' ],
          client           =>    true,
          } 
        class { '::localfiles::yum' :   }
        class { '::yum_cron':
          download_updates => true,
          apply_updates    => false,
          days_of_week     => '45',

          }
        file_line {'cron_daily':
          ensure   => 'present',
          path     => '/etc/anacrontab',
          match    => '^START_HOURS_RANGE*',
          multiple => 'true',
          line     => 'START_HOURS_RANGE=1-5',
          replace  =>  'true',
          }

}
        
#        firewall { '000 allow all snmp':
#          dport                   => '161',
#          proto                   => ['tcp', 'udp' ],
#          action                  => 'accept',
#        }



