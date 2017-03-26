class profiles::logstash (
  String $psql_ip,
  String $psql_user,
  String $psql_pw,
){

  # install and configure logstash
  contain ::logstash

  # get the plugin
  logstash::plugin{'logstash-output-jdbc':
    ensure =>  present,
  }

  # create the config
  logstash::configfile{'logstash.conf':
    content => epp("${module_name}/logstash.conf.epp"),
  }

  # get the jdbc driver
  archive{'/usr/share/logstash/vendor/jar/jdbc/postgresql-42.0.0.jar':
    ensure => 'present',
    source => 'https://jdbc.postgresql.org/download/postgresql-42.0.0.jar',
    user   => 'logstash',
    group  => 'logstash',
    notify => Service['logstash'],
  }
}
