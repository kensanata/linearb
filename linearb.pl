#!/usr/bin/env perl
use Mojolicious::Lite;
use Encode;
use utf8;

my %hash = (
  'da' => '𐀅',
  'de' => '𐀆',
  'di' => '𐀇',
  'do' => '𐀈',
  'du' => '𐀉',
  'ja' => '𐀊',
  'je' => '𐀋',
  'jo' => '𐀍',
  'ka' => '𐀏',
  'ke' => '𐀐',
  'ki' => '𐀑',
  'ko' => '𐀒',
  'ku' => '𐀓',
  'ma' => '𐀔',
  'me' => '𐀕',
  'mi' => '𐀖',
  'mo' => '𐀗',
  'mu' => '𐀘',
  'na' => '𐀙',
  'ne' => '𐀚',
  'ni' => '𐀛',
  'no' => '𐀜',
  'nu' => '𐀝',
  'pa' => '𐀞',
  'pe' => '𐀟',
  'pi' => '𐀠',
  'po' => '𐀡',
  'pu' => '𐀢',
  'qa' => '𐀣',
  'qe' => '𐀤',
  'qi' => '𐀥',
  'qo' => '𐀦',
  'ra' => '𐀨',
  're' => '𐀩',
  'ri' => '𐀪',
  'ro' => '𐀫',
  'ru' => '𐀬',
  'la' => '𐀨',
  'le' => '𐀩',
  'li' => '𐀪',
  'lo' => '𐀫',
  'lu' => '𐀬',
  'sa' => '𐀭',
  'se' => '𐀮',
  'si' => '𐀯',
  'so' => '𐀰',
  'su' => '𐀱',
  'ta' => '𐀲',
  'te' => '𐀳',
  'ti' => '𐀴',
  'to' => '𐀵',
  'tu' => '𐀶',
  'wa' => '𐀷',
  'we' => '𐀸',
  'wi' => '𐀹',
  'wo' => '𐀺',
  'za' => '𐀼',
  'ze' => '𐀽',
  'zo' => '𐀿',
  'a' => '𐀀',
  'e' => '𐀁',
  'i' => '𐀂',
  'o' => '𐀃',
  'u' => '𐀄');

any '/' => sub {
  my $self = shift;
  my $input = $self->param('input');
  my $result = $input;
  # sort by largest key first
  for my $syllable (sort { length($b) <=> length($a) } keys %hash) {
    $result =~ s/$syllable/$hash{$syllable}/gi;
  }
  $self->render('index', input => $input, result => $result);
} => 'main';

app->start;

__DATA__

@@ index.html.ep
% layout 'default';
% title 'To Linear B';
<h1>To Linear B</h1>
<blockquote>
Linear B is a syllabic script that was used for writing Mycenaean Greek, the
earliest attested form of Greek.<br>
<span style="font-size:80%">– <a href="https://en.wikipedia.org/wiki/Linear_B">Wikipedia</a></span>
</blockquote>
<p>
Type some text into this text area:
<p>
<form method="POST">
<textarea name='input' autofocus='autofocus' required='required' maxlength='10000'>
<%= $input %>
</textarea>
<button formaction='/'>Translate</button>
</form>
% if ($result) {
<p>
The result of the translation:
<p>
<%= $result %>
% }

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
<head>
<title><%= title %></title>
%= stylesheet '/linearb.css'
%= stylesheet begin
body {
  padding: 1em;
  font-family: "Palatino Linotype", "Book Antiqua", Palatino, serif;
}
label { width: 10ex; display: inline-block; }
button { width: 15ex; }
textarea {
 width: 100%;
 height: 10em;
}
% end
<meta name="viewport" content="width=device-width">
</head>
<body>
<%= content %>
<hr>
<p>
<a href="https://alexschroeder.ch/wiki/Contact">Alex Schroeder</a>&#x2003;<a href="https://github.com/kensanata/linearb">Source on GitHub</a>
</body>
</html>
