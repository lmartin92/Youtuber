private import parsers.ConfigurableBookmarkConverter;

void init_imported_converter() {
	instruction imported;
	imported.which_lines ~= 0;
	imported.which_lines ~= 2;
	imported.uniq_ident = "url";
	imported.pattern = "youtube";
	imported.locatables[placement.us] ~= "\"url\": \"";
	imported.locatables[placement.ue] ~= "\"";
	imported.locatables[placement.ue] ~= "&";
	imported.locatables[placement.ns] ~= "\"name\": \"";
	imported.locatables[placement.ne] ~= "\"";
	imported.locatables[placement.as] ~= "watch?v=";
	imported.locatables[placement.ae] ~= "\"";
	imported.locatables[placement.ae] ~= "&";
	imported.which_locatable[placement.us] = 0;
	imported.which_locatable[placement.ue] = 0;
	imported.which_locatable[placement.ns] = 0;
	imported.which_locatable[placement.ne] = 0;
	imported.which_locatable[placement.as] = 0;
	imported.which_locatable[placement.ae] = 0;
	
	ConfigurableBookmarkConverter.add_iset(imported);
}