#-*- perl -*-
#-*- coding: utf-8 -*-

use strict;
use warnings;

use Test::More tests => 1;
BEGIN { use_ok('Unicode::BiDiRule') };

use Unicode::UCD;
diag sprintf 'Unicode version %s', Unicode::UCD::UnicodeVersion();

