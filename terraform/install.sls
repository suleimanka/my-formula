{%- from 'terraform/settings.jinja' import terraform with context %}

"Terraform :: create install directory":
  file.directory:
    - name: /opt/terraform
    - user: root
    - group: root
    - mode: 755

{%- for ver in terraform.versions %}
"Terraform :: download and extract {{ ver }}":
  archive.extracted:
    - name: /opt/terraform/{{ ver }}
    - source: {{ terraform.url }}/{{ ver }}/terraform_{{ ver }}_{{ terraform.os }}_{{ terraform.arch }}.zip
    - archive_format: zip
    - if_missing: /opt/terraform/{{ ver }}/terraform
    - user: root
    - group: root
    - enforce_toplevel: False

"Terraform :: version {{ ver }} symlink":
  file.symlink:
    - name: /usr/local/bin/terraform-{{ ver }}
    - target: /opt/terraform/{{ ver }}/terraform
    - force: true
    - require:
      - archive: "Terraform :: download and extract {{ ver }}"
{%- endfor %}

"Terraform :: default version symlink":
  file.symlink:
    - name: /usr/local/bin/terraform
    - target: /opt/terraform/{{ terraform.default }}/terraform
    - force: true
    - require:
{%- for ver in terraform.versions %}
      - file: "Terraform :: version {{ ver }} symlink"
{%- endfor %}
