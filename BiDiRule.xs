#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "bidirule.c"

MODULE = Unicode::BiDiRule		PACKAGE = Unicode::BiDiRule		

int
_propname()
    ALIAS:
	UNKNOWN    = 0
	LTR        = BDR_LTR
	RTL        = BDR_RTL
	DISALLOWED = BDR_DISALLOWED
    CODE:
	RETVAL = ix;
    OUTPUT:
	RETVAL

void
check(string)
	SV *string
    PROTOTYPE: $
    PREINIT:
	char *buf;
	U8 *err;
	STRLEN buflen, errlen, errulen, idx;
	int retval;
	U32 cp;
    PPCODE:
	if (SvOK(string))
	    buf = SvPV(string, buflen);
	else
	    XSRETURN_EMPTY;

	switch (GIMME_V) {
	case G_SCALAR:
	    retval = bidirule_check((U8 *)buf, buflen,
		NULL, NULL, NULL, NULL, NULL);
	    if (retval != BDR_DISALLOWED) {
		XPUSHs(sv_2mortal(newSViv(retval)));
		XSRETURN(1);
	    } else
		XSRETURN_EMPTY;

	case G_ARRAY:
	    retval = bidirule_check((U8 *)buf, buflen,
		&err, &errlen, &errulen, &idx, &cp);
	    XPUSHs(sv_2mortal(newSVpv("result", 0)));
	    XPUSHs(sv_2mortal(newSViv(retval)));
	    XPUSHs(sv_2mortal(newSVpv("offset", 0)));
	    if (SvUTF8(string))
		XPUSHs(sv_2mortal(newSViv(idx)));
	    else
		XPUSHs(sv_2mortal(newSViv(err - (U8 *)buf)));
	    if (retval != BDR_DISALLOWED || errlen == 0)
		XSRETURN(4);

	    XPUSHs(sv_2mortal(newSVpv("length", 0)));
	    if (SvUTF8(string))
		XPUSHs(sv_2mortal(newSViv(errulen)));
	    else
		XPUSHs(sv_2mortal(newSViv(errlen)));
	    XPUSHs(sv_2mortal(newSVpv("ord", 0)));
	    XPUSHs(sv_2mortal(newSViv(cp)));
	    XSRETURN(8);

	default:
	    XSRETURN_EMPTY;
	}

