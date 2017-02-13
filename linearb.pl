#!/usr/bin/env perl
use Mojolicious::Lite;
use Encode;
use utf8;

# based on the tables in https://en.wikipedia.org/wiki/Linear_B#Syllabic_signs
# r = l
# f = p
# y = j
my @replacements = (
  '\bman\b' => '𐂀',
  '\bwoman\b' => '𐂁',
  '\bdeer\b' => '𐂂',
  '\bhorse\b' => '𐂃',
  '\bmare\b' => '𐂄',
  '\bstallion\b' => '𐂅',
  '\bsheep\b' => '𐀥',
  '\bewe\b' => '𐂆',
  '\bram\b' => '𐂇',
  '\bgoat\b' => '𐁒',
  '\bshe-goat\b' => '𐂈',
  '\bhe-goat\b' => '𐂉',
  '\bpig\b' => '𐁂',
  '\bsow\b' => '𐂊',
  '\bboar\b' => '𐂋',
  '\box\b' => '𐀘',
  '\bcow\b' => '𐂌',
  '\bbull\b' => '𐂍',
  '\bwheat\b' => '𐂎',
  '\bbarley\b' => '𐂏',
  '\bolives\b' => '𐂐',
  '\bfigs\b' => '𐀛',
  '\bflour\b' => '𐀎',
  '\b(condiment|aroma|spice)\b' => '𐂑',
  '\bsesame\b' => '𐀭',
  '\bcyperus\b' => '𐂒',
  '\bfruit\b' => '𐂓',
  '\bsafflower\b' => '𐂔',
  '\boil\b' => '𐂕',
  '\bwine\b' => '𐂖',
  '\bunguent\b' => '𐂘',
  '\bhoney\b' => '𐂙',
  '\bboiling pan\b' => '𐃟',
  '\btripod cauldron\b' => '𐃠',
  '\bgoblet\b' => '𐃡',
  '\bwine jar\b' => '𐃢',
  '\bewer\b' => '𐃣',
  '\bjug\b' => '𐃤',
  '\bhydria\b' => '𐃥',
  '\btripod amphora\b' => '𐃦',
  '\bbowl\b' => '𐃧',
  '\bamphora\b' => '𐃨',
  '\bstirrip jar\b' => '𐃩',
  '\bwater bowl\b' => '𐃪',
  '\bwater jar\b' => '𐃫',
  '\bcooking bowl\b' => '𐃬',
  '\bfootstool\b' => '𐃄',
  '\balveus\b' => '𐃅',
  '\bspear\b' => '𐃆',
  '\barrow\b' => '𐃇',
  '\bdagger\b' => '𐃉',
  '\bsword\b' => '𐃊',
  '\bwheeled chariot\b' => '𐃌',
  '\bwheel-less chariot\b' => '𐃍',
  '\bchariot frame\b' => '𐃎',
  '\bwheel\b' => '𐃏',
  'da' => '𐀅',
  'de' => '𐀆',
  'di' => '𐀇',
  'do' => '𐀈',
  'du' => '𐀉',
  'ja' => '𐀊',
  'je' => '𐀋',
  'jo' => '𐀍',
  'ya' => '𐀊',
  'ye' => '𐀋',
  'yo' => '𐀍',
  'c' => 'k',
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
  'f' => 'p',
  'pa' => '𐀞',
  'pe' => '𐀟',
  'pi' => '𐀠',
  'po' => '𐀡',
  'pu' => '𐀢',
  'b' => 'q',
  'qa' => '𐀣',
  'qe' => '𐀤',
  'qi' => '𐀥',
  'qo' => '𐀦',
  'l' => 'r',
  'ra' => '𐀨',
  're' => '𐀩',
  'ri' => '𐀪',
  'ro' => '𐀫',
  'ru' => '𐀬',
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
  'v' => 'w',
  'wa' => '𐀷',
  'we' => '𐀸',
  'wi' => '𐀹',
  'wo' => '𐀺',
  'za' => '𐀼',
  'ze' => '𐀽',
  'zo' => '𐀿',
  'ha' => '𐁀',
  'ai' => '𐁁',
  'au' => '𐁂',
  'dwe' => '𐁃',
  'dwo' => '𐁄',
  'nwa' => '𐁅',
  'pte' => '𐁇',
  'fte' => '𐁇',
  'phu' => '𐁆',
  'rya' => '𐁈',
  'lya' => '𐁈',
  'rai' => '𐁉',
  'lai' => '𐁉',
  'ryo' => '𐁊',
  'lyo' => '𐁊',
  'tya' => '𐁋',
  'twe' => '𐁌',
  'two' => '𐁍',
  'swi' => '𐁘',
  'ju' => '𐀎',
  'zu' => '𐁙',
  'swa' => '𐁚',
  '[sn]+\b' => '',
  '\bh' => '',
  '(?<=i)a' => 'ja', # i-ja
  '(?<=i)e' => 'je', # i-je
  '(?<=i)o' => 'jo', # i-jo
  '(?<=u)a' => 'wa', # u-wa
  '(?<=u)e' => 'we', # u-we
  '(?<=u)i' => 'wi', # u-wi
  '(?<=u)o' => 'wo', # u-wo
  'n(?![aeiou])' => '',
  '\b[sw](?![aeiou])' => '',
  '(?<=[aeiou])[lmnrs]' => '',
  'a' => '𐀀',
  'e' => '𐀁',
  'i' => '𐀂',
  'o' => '𐀃',
  'u' => '𐀄',
);

any '/' => sub {
  my $self = shift;
  my $input = $self->param('input');
  my $result = $input;
  my @todo = @replacements;
  while (@todo) {
    my $re = shift(@todo);
    my $to = shift(@todo);
    $result =~ s/$re/$to/gi;
  }
  # how to implement?
  #   '([^aeiou])([^aeiou])([aeiou])' => '$1$3$2$3',
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
<button>Translate</button>
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
