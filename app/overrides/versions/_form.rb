Deface::Override.new :virtual_path  => "versions/_form",
                     :name               => "add-load-to-versions",
                     :insert_before      => "erb[silent]:contains('@version.custom_field_values')",
                     :text               =>  "<p><%= f.select :version_load_id, VersionLoad.all.map {|v| [v.name, v.id]} %></p>"
