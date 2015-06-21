use 5.008;

package MY;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME               => 'Unicode::BiDiRule',
    VERSION_FROM       => 'lib/Unicode/BiDiRule.pm',
    MIN_PERL_VERSION   => 5.008,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '6.26',
        'Test::More'          => '0.45',
    },
    PREREQ_PM => {
        Exporter => '0',
        XSLoader => '0',
    },
    ABSTRACT_FROM => 'lib/Unicode/BiDiRule.pm',
    AUTHOR        => 'Hatuka*nezumi - IKEDA Soji <hatuka@nezumi.nu>',
    LIBS          => [''],
    DEFINE        => '',
    INC           => '-I.',
    dist          => {PREOP => '$(MAKE) preop',},
);

sub clean {
    my $inherited = shift->SUPER::clean(@_);
    $inherited =~ s{(:+[ \t]*)}{$1clean-c };
    $inherited;
}

sub postamble {
    return <<"EOF";
BiDiRule.c: stamp-c

stamp-c: data/bidirule.pl bidirule.c
\t\$(PERL) data/bidirule.pl bidirule.c
\t\$(TOUCH) stamp-c

clean-c:
\t\$(PERL) data/bidirule.pl --init bidirule.c
\t\$(RM_F) stamp-c

preop:
\t\$(PERL) data/bidirule.pl --init \$(DISTVNAME)/bidirule.c
\t\$(RM_F) \$(DISTVNAME)/bidirule.c.old

EOF
}
