private import parsers.ConfigurableBookmarkConverter;

void init_logger_converter() {
	instruction logger;
	logger.which_lines ~= 0;
	logger.uniq_ident = ":::";
	logger.pattern = "youtube";
	logger.locatables[placement.us] ~= ",,,";
	logger.locatables[placement.ue] ~= ":::";
	logger.locatables[placement.ns] ~= ":::";
	logger.locatables[placement.ne] ~= ";;;";
	logger.locatables[placement.as] ~= ";;;";
	logger.locatables[placement.ae] ~= "...";
	logger.which_locatable[placement.us] = 0;
	logger.which_locatable[placement.ue] = 0;
	logger.which_locatable[placement.ns] = 0;
	logger.which_locatable[placement.ne] = 0;
	logger.which_locatable[placement.as] = 0;
	logger.which_locatable[placement.ae] = 0;
	
	ConfigurableBookmarkConverter.add_iset(logger);
}