Deface::Override.new :virtual_path       => "versions/_form",
                     :name               => "add-load-to-versions",
                     :insert_bottom      => "div.tabular",
                     :text               =>  "<p><%= f.select :version_load_id, VersionLoad.all.map {|v| [v.name, v.id]} %></p>"
