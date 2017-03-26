class profiles::collectd (
 String $logstash_ip
){
  class{'::collectd':
    purge        => true,
    recurse      => true,
    purge_config => true,
    fqdnlookup   => false,
  }
  # connect to logstash
  collectd::plugin::network::server{$logstash_ip:
    port => 25826,
  }

  # collect cpu stats
  class{'::collectd::plugin::cpu':
    reportbystate    => true,
    reportbycpu      => true,
    valuespercentage => true,
    reportnumcpu     => true,
  }

  # collect disk stats
  class { 'collectd::plugin::df':
    fstypes          => ['nfs','tmpfs','autofs','gpfs','proc','devpts'],
    ignoreselected   => true,
    valuespercentage => true,
  }

  # collect cpu frquency stats
  contain '::collectd::plugin::cpufreq'

  # collect network stats
  include '::collectd::plugin::conntrack'
}
