{% from 'terraform/settings.jinja' import terraform with context %}

"Terraform :: ensure base dir":
  file.directory:
    - name: /opt/terraform
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

{%- for ver in terraform.versions %}

"Terraform :: download archive for {{ ver }}":
  file.managed:
    - name: /opt/terraform/terraform_{{ ver }}_{{ terraform.os }}_{{ terraform.arch }}.zip
    - source: "{{ terraform.url }}/{{ ver }}/terraform_{{ ver }}_{{ terraform.os }}_{{ terraform.arch }}.zip"
    - skip_verify: {{ terraform.skip_verify|lower }}
    - user: root
    - group: root
    - mode: '0644'

"Terraform :: extract {{ ver }}":
  archive.extracted:
    - name: /opt/terraform/{{ ver }}
    - source: /opt/terraform/terraform_{{ ver }}_{{ terraform.os }}_{{ terraform.arch }}.zip
    - archive_format: zip
    - enforce_toplevel: False
    - if_missing: /opt/terraform/{{ ver }}/terraform
    - user: root
    - group: root
    - require:
      - file: "Terraform :: download archive for {{ ver }}"

"Terraform :: version {{ ver }} symlink":
  file.symlink:
    - name: /usr/local/bin/terraform-{{ ver }}
    - target: /opt/terraform/{{ ver }}/terraform
    - force: True
    - require:
      - archive: "Terraform :: extract {{ ver }}"

{%- endfor %}

"Terraform :: default version symlink":
  file.symlink:
    - name: /usr/local/bin/terraform
    - target: /usr/local/bin/terraform-{{ terraform.default }}
    - force: True
    - require:
      - file: "Terraform :: version {{ terraform.default }} symlink"
