class profiles::grafana {

  class{'::grafana':
  }

  grafana_dashboard{'example_dashboard':
    grafana_url      => 'http://localhost:3000',
    grafana_user     => 'admin',
    grafana_password => 'admin',
    content          => template('profiles/grafana_dashboard.json.erb'),
  }

  grafana_datasource{'influxdb':
    grafana_url      => 'http://localhost:3000',
    grafana_user     => 'admin',
    grafana_password => 'admin',
    type             => 'influxdb',
    url              => 'http://localhost:8086',
    user             => 'admin',
    password         => 'test123',
    database         => 'ressources',
    access_mode      => 'proxy',
    is_default       => true,
  }
}
