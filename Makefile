#
# Makefile
#
# The global Makefile for POCO [generated by mkrelease]
#

sinclude config.make
sinclude config.build

ifndef POCO_BASE
$(warning WARNING: POCO_BASE is not defined. Assuming current directory.)
export POCO_BASE=$(shell pwd)
endif

ifndef POCO_BUILD
export POCO_BUILD=$(POCO_BASE)
endif

#
# Determine OS
#
POCO_HOST_OSNAME = $(shell uname)
ifeq ($(findstring CYGWIN,$(POCO_HOST_OSNAME)),CYGWIN)
POCO_HOST_OSNAME = Cygwin
endif

ifeq ($(findstring MINGW,$(POCO_HOST_OSNAME)),MINGW)
POCO_HOST_OSNAME = MinGW
endif
POCO_HOST_OSARCH ?= $(subst /,-,$(shell uname -m | tr ' ' _))

#
# If POCO_CONFIG is not set, use the OS name as configuration name
#
ifndef POCO_CONFIG
POCO_CONFIG = $(POCO_HOST_OSNAME)
endif

#
# Include System Specific Settings
#
include $(POCO_BASE)/build/config/$(POCO_CONFIG)

#
# Determine operating system
#
ifndef POCO_TARGET_OSNAME
OSNAME   := $(POCO_HOST_OSNAME)
else
OSNAME   := $(POCO_TARGET_OSNAME)
endif

ifndef POCO_TARGET_OSARCH
OSARCH   := $(POCO_HOST_OSARCH)
else
OSARCH   := $(POCO_TARGET_OSARCH)
endif

.PHONY: poco all libexecs cppunit tests samples cleans clean distclean install uninstall

# TESTS and SAMPLES are set in config.make
poco: libexecs $(if $(TESTS),tests) $(if $(SAMPLES),samples)
all: libexecs tests samples

INSTALLDIR = $(DESTDIR)$(POCO_PREFIX)

COMPONENTS =  CppUnit Foundation Encodings XML JSON Util Net Crypto NetSSL_OpenSSL
COMPONENTS += SQL SQL/ODBC SQL/SQLite SQL/MySQL SQL/PostgreSQL
COMPONENTS += MongoDB Redis Zip PageCompiler PageCompiler/File2Page CppParser

cppunit:
	$(MAKE) -C $(POCO_BASE)/CppUnit

CppUnit-clean:
	$(MAKE) -C $(POCO_BASE)/CppUnit clean

install: libexecs
	mkdir -p $(INSTALLDIR)/include/Poco
	mkdir -p $(INSTALLDIR)/lib
	mkdir -p $(INSTALLDIR)/bin
	for comp in $(filter-out $(foreach f,$(OMIT),$f%),$(COMPONENTS)) ; do \
		if [ -d "$(POCO_BASE)/$$comp/include" ] ; then \
			cp -Rf $(POCO_BASE)/$$comp/include/* $(INSTALLDIR)/include/ ; \
		fi ; \
		if [ -d "$(POCO_BUILD)/$$comp/bin" ] ; then \
			find $(POCO_BUILD)/$$comp/bin -perm -700 -type f -exec cp -f {} $(INSTALLDIR)/bin \; ; \
		fi ; \
	done
ifeq ($(OSNAME), Cygwin)
	find $(POCO_BUILD)/lib/$(OSNAME)/$(OSARCH) -name "cygPoco*" -type f -exec cp -f  {} $(INSTALLDIR)/bin \;
	find $(POCO_BUILD)/lib/$(OSNAME)/$(OSARCH) -name "cygPoco*" -type l -exec cp -Rf {} $(INSTALLDIR)/bin \;
endif
	find $(POCO_BUILD)/lib/$(OSNAME)/$(OSARCH) -name "libPoco*" -type f -exec cp -f  {} $(INSTALLDIR)/lib \;
	find $(POCO_BUILD)/lib/$(OSNAME)/$(OSARCH) -name "libPoco*" -type l -exec cp -Rf {} $(INSTALLDIR)/lib \;

uninstall:
	[ -d $(INSTALLDIR)/include/Poco ] && rm -rf $(INSTALLDIR)/include/Poco || echo "No installed Poco headers found";
	[ -d $(INSTALLDIR)/include/CppUnit ] && rm -rf $(INSTALLDIR)/include/CppUnit || echo "No installed CppUnit headers found";
ifeq ($(OSNAME), Cygwin)
	find $(INSTALLDIR)/bin -name "cygPoco*" -type f -exec rm -f  {} \;
	find $(INSTALLDIR)/bin -name "cygPoco*" -type l -exec rm -f {} \;
endif
	find $(INSTALLDIR)/lib -name "libPoco*" -type f -exec rm -f  {} \;
	find $(INSTALLDIR)/lib -name "libPoco*" -type l -exec rm -f {} \;

# -------------------------------------------------------------------------------------------------------------------------------------
libexecs =  Foundation-libexec Encodings-libexec XML-libexec JSON-libexec Util-libexec Net-libexec Crypto-libexec NetSSL_OpenSSL-libexec
libexecs += SQL-libexec  SQL/ODBC-libexec SQL/SQLite-libexec SQL/MySQL-libexec SQL/PostgreSQL-libexec
libexecs += MongoDB-libexec Redis-libexec Zip-libexec PageCompiler-libexec PageCompiler/File2Page-libexec CppParser-libexec

# -------------------------------------------------------------------------------------------------------------------------------------
tests    =  Foundation-tests Encodings-tests XML-tests JSON-tests Util-tests Net-tests Crypto-tests NetSSL_OpenSSL-tests
tests    += SQL-tests SQL/ODBC-tests  SQL/SQLite-tests SQL/MySQL-tests SQL/PostgreSQL-tests
tests	 += MongoDB-tests Redis-tests Zip-tests CppParser-tests

# -------------------------------------------------------------------------------------------------------------------------------------
samples  =  Foundation-samples Encodings-samples XML-samples JSON-samples Util-samples Net-samples Crypto-samples NetSSL_OpenSSL-samples
samples  += SQL-samples
samples  += MongoDB-samples Zip-samples PageCompiler-samples

# -------------------------------------------------------------------------------------------------------------------------------------
cleans   =  Foundation-clean Encodings-clean XML-clean JSON-clean Util-clean Net-clean Crypto-clean NetSSL_OpenSSL-clean
cleans   += SQL-clean SQL/ODBC-clean SQL/SQLite-clean SQL/MySQL-clean SQL/PostgreSQL-clean
cleans	 += MongoDB-clean Redis-clean Zip-clean PageCompiler-clean PageCompiler/File2Page-clean CppParser-clean

# -------------------------------------------------------------------------------------------------------------------------------------
.PHONY: $(libexecs)
.PHONY: $(tests)
.PHONY: $(samples)
.PHONY: $(cleans)

libexecs: $(filter-out $(foreach f,$(OMIT),$f%),$(libexecs))
tests: $(filter-out $(foreach f,$(OMIT),$f%),$(tests))
samples: $(filter-out $(foreach f,$(OMIT),$f%),$(samples))
cleans: $(filter-out $(foreach f,$(OMIT),$f%),$(cleans))

Foundation-libexec:
	$(MAKE) -C $(POCO_BASE)/Foundation

Foundation-tests: Foundation-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/Foundation/testsuite

Foundation-samples: Foundation-libexec
	$(MAKE) -C $(POCO_BASE)/Foundation/samples

Foundation-clean:
	$(MAKE) -C $(POCO_BASE)/Foundation clean
	$(MAKE) -C $(POCO_BASE)/Foundation/testsuite clean
	$(MAKE) -C $(POCO_BASE)/Foundation/samples clean

Encodings-libexec:  Foundation-libexec
	$(MAKE) -C $(POCO_BASE)/Encodings

Encodings-tests: Encodings-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/Encodings/testsuite

Encodings-samples: Encodings-libexec
	$(MAKE) -C $(POCO_BASE)/Encodings/samples

Encodings-clean:
	$(MAKE) -C $(POCO_BASE)/Encodings clean
	$(MAKE) -C $(POCO_BASE)/Encodings/testsuite clean
	$(MAKE) -C $(POCO_BASE)/Encodings/samples clean

XML-libexec:  Foundation-libexec
	$(MAKE) -C $(POCO_BASE)/XML

XML-tests: XML-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/XML/testsuite

XML-samples: XML-libexec
	$(MAKE) -C $(POCO_BASE)/XML/samples

XML-clean:
	$(MAKE) -C $(POCO_BASE)/XML clean
	$(MAKE) -C $(POCO_BASE)/XML/testsuite clean
	$(MAKE) -C $(POCO_BASE)/XML/samples clean

JSON-libexec:  Foundation-libexec
	$(MAKE) -C $(POCO_BASE)/JSON

JSON-tests: JSON-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/JSON/testsuite

JSON-samples: JSON-libexec
	$(MAKE) -C $(POCO_BASE)/JSON/samples

JSON-clean:
	$(MAKE) -C $(POCO_BASE)/JSON clean
	$(MAKE) -C $(POCO_BASE)/JSON/testsuite clean
	$(MAKE) -C $(POCO_BASE)/JSON/samples clean

Util-libexec:  Foundation-libexec XML-libexec JSON-libexec
	$(MAKE) -C $(POCO_BASE)/Util

Util-tests: Util-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/Util/testsuite

Util-samples: Util-libexec
	$(MAKE) -C $(POCO_BASE)/Util/samples

Util-clean:
	$(MAKE) -C $(POCO_BASE)/Util clean
	$(MAKE) -C $(POCO_BASE)/Util/testsuite clean
	$(MAKE) -C $(POCO_BASE)/Util/samples clean

Net-libexec:  Foundation-libexec
	$(MAKE) -C $(POCO_BASE)/Net

Net-tests: Net-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/Net/testsuite

Net-samples: Net-libexec  Foundation-libexec XML-libexec Util-libexec
	$(MAKE) -C $(POCO_BASE)/Net/samples

Net-clean:
	$(MAKE) -C $(POCO_BASE)/Net clean
	$(MAKE) -C $(POCO_BASE)/Net/testsuite clean
	$(MAKE) -C $(POCO_BASE)/Net/samples clean

Crypto-libexec:  Foundation-libexec
	$(MAKE) -C $(POCO_BASE)/Crypto

Crypto-tests: Crypto-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/Crypto/testsuite

Crypto-samples: Crypto-libexec  Foundation-libexec Util-libexec
	$(MAKE) -C $(POCO_BASE)/Crypto/samples

Crypto-clean:
	$(MAKE) -C $(POCO_BASE)/Crypto clean
	$(MAKE) -C $(POCO_BASE)/Crypto/testsuite clean
	$(MAKE) -C $(POCO_BASE)/Crypto/samples clean

NetSSL_OpenSSL-libexec:  Foundation-libexec Net-libexec Util-libexec Crypto-libexec
	$(MAKE) -C $(POCO_BASE)/NetSSL_OpenSSL

NetSSL_OpenSSL-tests: NetSSL_OpenSSL-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/NetSSL_OpenSSL/testsuite

NetSSL_OpenSSL-samples: NetSSL_OpenSSL-libexec
	$(MAKE) -C $(POCO_BASE)/NetSSL_OpenSSL/samples

NetSSL_OpenSSL-clean:
	$(MAKE) -C $(POCO_BASE)/NetSSL_OpenSSL clean
	$(MAKE) -C $(POCO_BASE)/NetSSL_OpenSSL/testsuite clean
	$(MAKE) -C $(POCO_BASE)/NetSSL_OpenSSL/samples clean

SQL-libexec:  Foundation-libexec
	$(MAKE) -C $(POCO_BASE)/SQL

SQL-tests: SQL-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/SQL/testsuite

SQL-samples: SQL-libexec  SQL-libexec SQL/SQLite-libexec Net-libexec
	$(MAKE) -C $(POCO_BASE)/SQL/samples

SQL-clean:
	$(MAKE) -C $(POCO_BASE)/SQL clean
	$(MAKE) -C $(POCO_BASE)/SQL/testsuite clean
	$(MAKE) -C $(POCO_BASE)/SQL/samples clean

SQL/SQLite-libexec:  Foundation-libexec SQL-libexec
	$(MAKE) -C $(POCO_BASE)/SQL/SQLite

SQL/SQLite-tests: SQL/SQLite-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/SQL/SQLite/testsuite

SQL/SQLite-clean:
	$(MAKE) -C $(POCO_BASE)/SQL/SQLite clean
	$(MAKE) -C $(POCO_BASE)/SQL/SQLite/testsuite clean

SQL/ODBC-libexec:  Foundation-libexec SQL-libexec
	$(MAKE) -C $(POCO_BASE)/SQL/ODBC

SQL/ODBC-tests: SQL/ODBC-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/SQL/ODBC/testsuite

SQL/ODBC-clean:
	$(MAKE) -C $(POCO_BASE)/SQL/ODBC clean
	$(MAKE) -C $(POCO_BASE)/SQL/ODBC/testsuite clean

SQL/MySQL-libexec:  Foundation-libexec SQL-libexec
	$(MAKE) -C $(POCO_BASE)/SQL/MySQL

SQL/MySQL-tests: SQL/MySQL-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/SQL/MySQL/testsuite

SQL/MySQL-clean:
	$(MAKE) -C $(POCO_BASE)/SQL/MySQL clean
	$(MAKE) -C $(POCO_BASE)/SQL/MySQL/testsuite clean

SQL/PostgreSQL-libexec:  Foundation-libexec SQL-libexec
	$(MAKE) -C $(POCO_BASE)/SQL/PostgreSQL

SQL/PostgreSQL-tests: SQL/PostgreSQL-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/SQL/PostgreSQL/testsuite

SQL/PostgreSQL-clean:
	$(MAKE) -C $(POCO_BASE)/SQL/PostgreSQL clean
	$(MAKE) -C $(POCO_BASE)/SQL/PostgreSQL/testsuite clean

MongoDB-libexec:  Foundation-libexec Net-libexec
	$(MAKE) -C $(POCO_BASE)/MongoDB

MongoDB-tests: MongoDB-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/MongoDB/testsuite

MongoDB-samples: MongoDB-libexec
	$(MAKE) -C $(POCO_BASE)/MongoDB/samples

MongoDB-clean:
	$(MAKE) -C $(POCO_BASE)/MongoDB clean
	$(MAKE) -C $(POCO_BASE)/MongoDB/testsuite clean
	$(MAKE) -C $(POCO_BASE)/MongoDB/samples clean

Redis-libexec:  Foundation-libexec Net-libexec
	$(MAKE) -C $(POCO_BASE)/Redis

Redis-tests: Redis-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/Redis/testsuite

#No samples yet ... uncomment this when added, and add Redis-samples to samples above
#Redis-samples: Redis-libexec
#	$(MAKE) -C $(POCO_BASE)/Redis/samples

Redis-clean:
	$(MAKE) -C $(POCO_BASE)/Redis clean
	$(MAKE) -C $(POCO_BASE)/Redis/testsuite clean
#	$(MAKE) -C $(POCO_BASE)/Redis/samples clean

Zip-libexec:  Foundation-libexec Net-libexec Util-libexec XML-libexec
	$(MAKE) -C $(POCO_BASE)/Zip

Zip-tests: Zip-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/Zip/testsuite

Zip-samples: Zip-libexec
	$(MAKE) -C $(POCO_BASE)/Zip/samples

Zip-clean:
	$(MAKE) -C $(POCO_BASE)/Zip clean
	$(MAKE) -C $(POCO_BASE)/Zip/testsuite clean
	$(MAKE) -C $(POCO_BASE)/Zip/samples clean

PageCompiler-libexec:  Net-libexec Util-libexec XML-libexec Foundation-libexec
	$(MAKE) -C $(POCO_BASE)/PageCompiler

PageCompiler-samples: PageCompiler-libexec
	$(MAKE) -C $(POCO_BASE)/PageCompiler/samples

PageCompiler-clean:
	$(MAKE) -C $(POCO_BASE)/PageCompiler clean
	$(MAKE) -C $(POCO_BASE)/PageCompiler/samples clean

PageCompiler/File2Page-libexec:  Net-libexec Util-libexec XML-libexec Foundation-libexec
	$(MAKE) -C $(POCO_BASE)/PageCompiler/File2Page

PageCompiler/File2Page-clean:
	$(MAKE) -C $(POCO_BASE)/PageCompiler/File2Page clean

CppParser-libexec:  Foundation-libexec
	$(MAKE) -C $(POCO_BASE)/CppParser

CppParser-tests: CppParser-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/CppParser/testsuite

CppParser-clean:
	$(MAKE) -C $(POCO_BASE)/CppParser clean
	$(MAKE) -C $(POCO_BASE)/CppParser/testsuite clean

PDF-libexec:  Foundation-libexec
	$(MAKE) -C $(POCO_BASE)/PDF

PDF-tests: PDF-libexec cppunit
	$(MAKE) -C $(POCO_BASE)/PDF/testsuite

PDF-samples: PDF-libexec
	$(MAKE) -C $(POCO_BASE)/PDF/samples

PDF-clean:
	$(MAKE) -C $(POCO_BASE)/PDF clean
	$(MAKE) -C $(POCO_BASE)/PDF/testsuite clean
	$(MAKE) -C $(POCO_BASE)/PDF/samples clean

clean: cleans CppUnit-clean

distclean:
	rm -rf $(POCO_BUILD)/lib
	find $(POCO_BUILD) -name obj -type d -print0 | xargs -0 rm -rf
	find $(POCO_BUILD) -name .dep -type d -print0 | xargs -0 rm -rf
	find $(POCO_BUILD) -name bin -type d -print0 | xargs -0 rm -rf