-ifndef(GETTEXT_DOMAIN).
  %% regular gettext call
  -define(_(String), gettexter:gettext(String)).
  -define(__(String, Locale), gettexter:gettext(String, Locale)).

  %% ngettext - plural
  -define(N_(Singular, Plural, N), gettexter:ngettext(Singular, Plural, N)).
-define(N__(Singular, Plural, N, Locale), gettexter:ngettext(Singular, Plural, N, Locale)).

  %% pgettext (with msgctx)
  -define(P_(Context, String), gettexter:pgettext(Context, String)).
  -define(NP_(Context, Singular, Plural, N), gettexter:npgettext(Context, Singular, Plural, N)).

  -define(P__(Context, String, Locale), gettexter:pgettext(Context, String, Locale)).
  -define(NP__(Context, Singular, Plural, N, Locale), gettexter:npgettext(Context, Singular, Plural, N, Locale)).
-else.
  -define(_(String), ?D_(?GETTEXT_DOMAIN, String)).
  -define(N_(Singular, Plural, N), ?DN_(?GETTEXT_DOMAIN, Singular, Plural, N)).
  -define(P_(Context, String), ?DP_(?GETTEXT_DOMAIN, Context, String)).
  -define(NP_(Context, Singular, Plural, N), ?DNP_(?GETTEXT_DOMAIN, Context, Singular, Plural, N)).

  -define(__(String), ?D__(?GETTEXT_DOMAIN, String, Locale)).
  -define(N__(Singular, Plural, N), ?DN__(?GETTEXT_DOMAIN, Singular, Plural, N, Locale)).
  -define(P__(Context, String), ?DP__(?GETTEXT_DOMAIN, Context, String, Locale)).
  -define(NP__(Context, Singular, Plural, N), ?DNP__(?GETTEXT_DOMAIN, Context, Singular, Plural, N, Locale)).
-endif.

%% d*gettext - all the same, but with domain specified (should be used for library localization)
-define(D_(Domain, String), gettexter:dgettext(Domain, String)).
-define(DN_(Domain, Singular, Plural, N), gettexter:dngettext(Domain, Singular, Plural, N)).
-define(DP_(Domain, Context, String), gettexter:dpgettext(Domain, Context, String)).
-define(DNP_(Domain, Context, Singular, Plural, N), gettexter:dnpgettext(Domain, Context, Singular, Plural, N)).

-define(D__(Domain, String, Locale), gettexter:dgettext(Domain, String, Locale)).
-define(DN__(Domain, Singular, Plural, N, Locale), gettexter:dngettext(Domain, Singular, Plural, N, Locale)).
-define(DP__(Domain, Context, String, Locale), gettexter:dpgettext(Domain, Context, String, Locale)).
-define(DNP__(Domain, Context, Singular, Plural, N, Locale), gettexter:dnpgettext(Domain, Context, Singular, Plural, N, Locale)).


%% gettext noop
-define(NO_(String), String).
-define(NO__(String, Locale), String).
