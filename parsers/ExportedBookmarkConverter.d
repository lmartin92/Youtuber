private import parsers.ConfigurableBookmarkConverter;

void init_exported_converter() {
	instruction exported;
	exported.which_lines ~= 0;
	exported.uniq_ident = "HREF=\"";
	exported.pattern = "youtube";
	exported.locatables[placement.us] ~= "HREF=\"";
	exported.locatables[placement.ue] ~= "\"";
	exported.locatables[placement.ue] ~= "&list";
	exported.locatables[placement.ue] ~= "&feature";
	exported.locatables[placement.ns] ~= "\">";
	exported.locatables[placement.ne] ~= `</A>`;
	exported.locatables[placement.as] ~= "watch?v=";
	exported.locatables[placement.ae] ~= "\"";
	exported.locatables[placement.ae] ~= "&list";
	exported.locatables[placement.ae] ~= "&feature";
	exported.which_locatable[placement.us] = 0;
	exported.which_locatable[placement.ue] = 0;
	exported.which_locatable[placement.ns] = 0;
	exported.which_locatable[placement.ne] = 0;
	exported.which_locatable[placement.as] = 0;
	exported.which_locatable[placement.ae] = 0;
	
	ConfigurableBookmarkConverter.add_iset(exported);
}