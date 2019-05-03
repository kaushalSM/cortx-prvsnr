{% set role = 'gw' %}

{% if (not 'virtual' in salt['grains.get']('productname').lower()) %}

# START: Prepare for SSPL configuration for HW SSU only

# add_zabbix_user_in_sudoers_file:
#   file.line:
#     - name: /etc/sudoer
    # Add line after
    # %wheel ALL=(ALL) NOPASSWD: ALL
    # zabbix ALL=(ALL) NOPASSWD: ALL

ensure_directory_dcs_collector_conf_d:
  file.directory:
    - name: /etc/dcs_collector.conf.d
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode

ensure_file_dcs_collector_conf:
  file.managed:
    - name: /etc/dcs_collector.conf
    - contents: |
        # Placeholder configuration. New configuration will be generated by Puppet.
        [general]
        config_dir=/etc/dcs_collector.conf.d/

        [hpi]

        [hpi_monitor]
    - require:
      - file: ensure_directory_dcs_collector_conf_d

service_dcs_collector:
  cmd.run:
    - name: /etc/rc.d/init.d/dcs-collector start
    - require:
      - file: ensure_file_dcs_collector_conf

# END: Prepare for SSPL configuration

{% else %}
{% set role = 'vm' %}

# Execute only on Virtual Machine
update_sspl_ll_conf:
  file.replace:
    - name: /etc/sspl_ll.conf
    - pattern: setup=.*$
    - repl: setup=vm
    - append_if_not_found: True

{% endif %}

execute_sspl_init:
  cmd.run:
    - name: /opt/seagate/sspl/sspl_init config -f -r {{ role }}
    - onlyif: test -f /opt/seagate/sspl/sspl_init