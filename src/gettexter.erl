%%% @author Sergey Prokhorov <me@seriyps.ru>
%%% @copyright (C) 2014, Sergey Prokhorov
%%% @doc
%%% Gettexter main interface module.
%%% @end
%%% Created : 25 Feb 2014 by Sergey Prokhorov <me@seriyps.ru>

-module(gettexter).
-export([gettext/1, pgettext/2, dgettext/2, dpgettext/3]).
-export([ngettext/3, npgettext/4, dngettext/4, dnpgettext/5]).

-export([gettext/2, pgettext/3, dgettext/3, dpgettext/4]).
-export([ngettext/4, npgettext/5, dngettext/5, dnpgettext/6]).
-export([bindtextdomain/2]).
-export([setlocale/2, getlocale/1]).
-export([textdomain/0, textdomain/1]).
-export([bind_textdomain_codeset/2]).
-export([which_domains/1, which_locales/1, ensure_loaded/3, reset/0]).

%% Lookup APIs
gettext(Msgid) -> dpgettext(undefined, undefined, Msgid).
ngettext(Singular, Plural, N) -> dnpgettext(undefined, undefined, Singular, Plural, N).
pgettext(Context, Msgid) -> dpgettext(undefined, Context, Msgid).
npgettext(Context, Singular, Plural, N) -> dnpgettext(undefined, Context, Singular, Plural, N).

dgettext(Domain, Msgid) -> dpgettext(Domain, undefined, Msgid).
dngettext(Domain, Singular, Plural, N) -> dnpgettext(Domain, undefined, Singular, Plural, N).

-spec dpgettext(atom(), string() | undefined, string()) -> string().
dpgettext(Domain, Context, Msgid) ->
    Locale = getlocale(lc_messages),
    dpgettext(Domain, Context, Msgid, Locale).

-spec dnpgettext(atom(), string() | undefined, string(), string(), integer()) -> string().
dnpgettext(Domain, Context, Singular, Plural, N) ->
    Locale = getlocale(lc_messages),
    dnpgettext(Domain, Context, Singular, Plural, N, Locale).




gettext(Msgid, Locale) -> dpgettext(undefined, undefined, Msgid, Locale).
ngettext(Singular, Plural, N, Locale) -> dnpgettext(undefined, undefined, Singular, Plural, N, Locale).
pgettext(Context, Msgid, Locale) -> dpgettext(undefined, Context, Msgid, Locale).
npgettext(Context, Singular, Plural, N, Locale) -> dnpgettext(undefined, Context, Singular, Plural, N, Locale).

dgettext(Domain, Msgid, Locale) -> dpgettext(Domain, undefined, Msgid, Locale).
dngettext(Domain, Singular, Plural, N, Locale) -> dnpgettext(Domain, undefined, Singular, Plural, N, Locale).

-spec dpgettext(atom(), string() | undefined, string(), string()) -> string().
dpgettext(Domain, Context, Msgid, Locale) ->
    Domain1 = if Domain == undefined -> textdomain();
                 true -> Domain
              end,
    case gettexter_server:dpgettext(Domain1, Context, Locale, Msgid) of
        undefined -> Msgid;
        Msgstr -> Msgstr
    end.

-spec dnpgettext(atom(), string() | undefined, string(), string(), integer(), string()) -> string().
dnpgettext(Domain, Context, Singular, Plural, N, Locale) ->
    Domain1 = if Domain == undefined -> textdomain();
                  true -> Domain
              end,
    case gettexter_server:dnpgettext(Domain1, Context, Locale, Singular, Plural, N) of
        undefined when N == 1 -> Singular;
        undefined -> Plural;
        Msgstr -> Msgstr
    end.

%% Configuration APIs
-spec bindtextdomain(atom(), file:filename()) -> ok.
bindtextdomain(Domain, LocaleDir) ->
    gettexter_server:bindtextdomain(Domain, LocaleDir).

-spec setlocale(atom(), string()) -> ok.
setlocale(Category=lc_messages, Locale) ->
    TextDomain = textdomain(),
    true = (TextDomain =/= undefined),          %assert
    put({?MODULE, locale, TextDomain, Category}, Locale),
    {ok, _} = gettexter_server:ensure_loaded(TextDomain, Category, Locale),
    ok.

-spec getlocale(atom()) -> string() | undefined.
getlocale(Category=lc_messages) ->
    TextDomain = textdomain(),
    get({?MODULE, locale, TextDomain, Category}).

-spec textdomain(atom()) -> ok.
textdomain(Domain) ->
    put({?MODULE, textdomain}, Domain).

-spec textdomain() -> atom() | undefined.
textdomain() ->
    get({?MODULE, textdomain}).

-spec bind_textdomain_codeset(atom(), string()) -> ok.
bind_textdomain_codeset(_Domain, _Charset) ->
    error(not_implemented).

%% Proprietary APIs (not defined in GNU gettext, but may be usefull for Erlang apps).

%% @doc
%% Which domains are loaded for `Locale'.
-spec which_domains(string()) -> [atom()].
which_domains(Locale) ->
    gettexter_server:which_domains(Locale).

%% @doc
%% Which locales are loaded for `Domain'.
-spec which_locales(atom()) -> [string()].
which_locales(Domain) ->
    gettexter_server:which_locales(Domain).

%% @doc
%% Ensure, that locale is loaded from .mo file to gettexter server. If locale
%% isn't loaded, all `gettext' lookups to it will return default value `Msgid'.
%% This function may be called at application start-up or configuration time,
%% once for each supported locale.
-spec ensure_loaded(atom(), lc_messages, string()) -> {ok, already | file:filename()} | {error, term()}.
ensure_loaded(TextDomain, Category=lc_messages, Locale) ->
    gettexter_server:ensure_loaded(TextDomain, Category, Locale).

%% @doc
%% Remove all gettext stuff from process dictionary (but not from locale data storage).
-spec reset() -> ok.
reset() ->
    lists:foreach(fun({Key, _}) when element(1, Key) == ?MODULE -> erase(Key);
                     (_) -> ok
                  end,
                 get()),
    ok.
%% Internal
%% maybe add some abstraction around get/put here?
