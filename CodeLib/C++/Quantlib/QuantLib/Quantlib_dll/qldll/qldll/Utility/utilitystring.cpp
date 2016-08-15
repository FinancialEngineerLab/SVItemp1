
#include <qldll/qldll/utility/utilitystring.h>

std::string uppercase(const std::string &s) {
	return boost::algorithm::to_upper_copy(s);
}