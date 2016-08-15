#include <qldll/qldll/Option/optiontype.h>

Option::Type getOptionEnumType(std::string strOptionType)
{
	std::string strUpperCaseOptionType = uppercase(strOptionType);
	if (strUpperCaseOptionType == "CALL")
		return Option::Type::Call;
	else if (strUpperCaseOptionType == "PUT")
		return Option::Type::Put;
	else if (strUpperCaseOptionType == "BARRIER")
		return Option::Type::Barrier;
	else
		std::exception("getOptionEnumType: wrong option type");
}