	
	%--- History ---%
	% 22/11/26------version 3
	% 22/11/28------version 3.1
	% 22/12/10------version 3.14
	% 22/12/12------version 3.145
	% 23/04/26------version 3.14159
	% 24/08/19------version 3.141592
	% 24/10/22------version 3.1415926


	% originated by junsrt.bst
	% version 
	FUNCTION {REVTeX-ja.version} { "3.1415926" }
	
	FUNCTION {id.bst} {"bst derived from REVTeX-ja.bst"}

ENTRY
  { address
    author
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    volume
    year
    yomi
    eprint 
    doi 
    pubmed 
    url 
    lastchecked 
  }
  {is.kanji.entry}

  { label }


INTEGERS { output.state before.all mid.sentence after.sentence after.block }

INTEGERS { punctuation.state punctuation.no punctuation.space punctuation.yes }

FUNCTION {diagn.cmntlog}
{
duplicate$ top$ "%" swap$ * write$ newline$
}

INTEGERS { control.key control.author control.editor control.title control.pages control.eprint control.year }

INTEGERS { control.author.jnrlst control.author.dotless control.author.nospace control.author.initials control.author.nocomma control.author.first control.author.reversed }

FUNCTION { control.init }
{
	#0
	'control.key             :=
	#0
	#8 +
	#64 +
	'control.author :=
	#1
	'control.author.jnrlst   :=
	#0
	'control.author.dotless  :=
	#0
	'control.author.nospace  :=
	#1
	'control.author.initials :=
	#0
	'control.author.nocomma  :=
	#0
	'control.author.first    :=
	#0
	'control.author.reversed :=
	#1
	'control.editor :=
	#-1
	'control.title  :=
	#0
	'control.pages  :=
	#0
	'control.eprint :=
	#1
	'control.year   :=
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}
FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}
FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}
FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=

}
STRINGS { s t }

FUNCTION {bbl.comma}
{ "," }

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =

    { ", " * write$ }

    { output.state after.block =
	{ 

          bbl.comma * write$

	  newline$
	  "\newblock " write$
	}

	{ output.state before.all =
	    'write$

	    { bbl.comma * " " * write$}

	  if$
	}

      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output.nonnullNONEcomma}
{ 's :=
  output.state mid.sentence =
    { " " * write$ }
    { output.state after.block =
        { add.period$ write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
            'write$
            { add.period$ " " * write$ }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output.NONE}
{ 's :=
output.state mid.sentence =
{ "" * write$ }
{ output.state after.block =
{ add.period$ write$
newline$
"\newblock " write$
}
{ output.state before.all =
'write$
{ add.period$ "" * write$ }
if$
}
if$
mid.sentence 'output.state :=
}
if$
s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.nopunct}
{
punctuation.no 'punctuation.state :=
output.nonnull
}

FUNCTION {output.checkNONEcomma}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnullNONEcomma
  if$
}

FUNCTION {output.nNONE}
{ 't :=
duplicate$ empty$
{ pop$ "empty " t * " in " * cite$ * warning$ }
'output.NONE
if$
}


FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}
FUNCTION {output.bibitem}
{ newline$

  "\bibitem{" write$

  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}
FUNCTION {fin.entry}
{ 

  add.period$

  write$
  newline$
}
FUNCTION {new.block}
{ output.state before.all =

    'skip$
    { after.block 'output.state := }

  if$
}
FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
	'skip$
	{ after.sentence 'output.state := }
      if$
    }
  if$
}
FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}
FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}
FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}
FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}


FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { duplicate$ is.kanji.str$
	'skip$
	{ "{\it " swap$ * "}" * }
      if$
    }
  if$
}

FUNCTION {bold}
{ duplicate$ empty$
    { pop$ "" }
    { "{\bfseries " swap$ * "}" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}		
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{f.}{ll}" format.name$ is.kanji.str$
	{s nameptr "{ff}{ll}" format.name$ 't :=}
 	{s nameptr "{f.~}{v.~}{ll}{, jj}" format.name$ 't :=}
      if$
      nameptr #1 >
	{ namesleft #1 >
	    {", " * t * }
	    { t "others" =
 		{ s is.kanji.str$
 			{"$B$[$+(B" * }
 			{", et~al." * }
 		  if$
 		}
 		{ s is.kanji.str$
 		    {", " * t * }
		    { numnames #2 =
 			{" and " * t * }
 			{", and " * t * }
		      if$
		    }
 		   if$
 		}
	      if$
	    }
	  if$
	}
	't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

STRINGS { bibfield output.bibfield }

FUNCTION {format.names.et.al.}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
%%%------------------------------%%%
numnames #3 >	%%---	著者数が〇人以上でet al.形式にしたいとき、ここの数字を〇にする(default : 3)。
{
  	#2 'namesleft :=		%%---	第〇著者以降を省略する(default : 2)。
  	{ namesleft #0 > }
  	{ s nameptr "{f.}{ll}" format.name$ is.kanji.str$
  		{s nameptr "{ff}{ll}" format.name$ 't :=}
  		{s nameptr "{f.~}{v.~}{ll}{, jj}" format.name$ 't :=}
  		if$
  		nameptr #1 >
  		{ namesleft #1 >
  			{ ", " * t * }
  			{ " {\it et~al}." *}
  			if$
  		}
  		't  
  		if$
  		nameptr #1 + 'nameptr :=
  		namesleft #1 - 'namesleft :=
  	}
  	while$
  }
{	  
%%%------------------------------%%%
    { namesleft #0 > }
    { s nameptr "{f.}{ll}" format.name$ is.kanji.str$
	{s nameptr "{ff}{ll}" format.name$ 't :=}
 	{s nameptr "{f.~}{v.~}{ll}{, jj}" format.name$ 't :=}
      if$
      nameptr #1 >
	{ namesleft #1 >
	    {", " * t * }
	    { t "others" =
 		{ s is.kanji.str$
 			{"$B$[$+(B" * }
 			{", et~al." *}
 		  if$
 		}
 		{ s is.kanji.str$
 		    {", " * t * }
		    { numnames #2 =
 			{" and " * t * }
 			{", and " * t * }
		      if$
		    }
 		   if$
 		}
	      if$
	    }
	  if$
	}
	't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
  }
if$
}


FUNCTION {format.authors}
{ author empty$
    { "" }

    { author format.names}	
% { author format.names.et.al.}	% et.al.表記にしたいときはこっち

  if$
}
FUNCTION {format.editors}
{ editor empty$
    { "" }

    { editor format.names	
% { editor format.names.et.al.	% et.al.表記にしたいときはこっち
      editor num.names$ #1 >
 	{ editor is.kanji.str$

 		{"$B!JJT!K(B" * } {", editors" * } if$

 	}
 	{ editor is.kanji.str$

 		{"$B!JJT!K(B" *} {", editor" * } if$

 	}
      if$
    }
  if$
}

FUNCTION {format.title}

{ title empty$

    { "" }


    { title }


  if$
}


FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
	{ t #1 #2 substring$ "--" = not
	    { "--" *
	      t #2 global.max$ substring$ 't :=
	    }
	    {   { t #1 #1 substring$ "-" = }
		{ "-" *
		  t #2 global.max$ substring$ 't :=
		}
	      while$
	    }
	  if$
	}
	{ t #1 #1 substring$ *
	  t #2 global.max$ substring$ 't :=
	}
      if$
    }
  while$
}

FUNCTION {format.date}

{ year empty$
{ month empty$
{ "" }
{ "there's a month but no year in " cite$ * warning$
month
}
if$
}
{ month empty$
'year
{ month " " * year * }
if$
}
if$
}

FUNCTION {format.OnlyYear}

{ year empty$
	'year
	{ year }
      if$
  " (" swap$ * ")" *
}

FUNCTION {format.bOnlyYear}

{ year empty$
'year
{ year }
if$
" " swap$ * "" *
}

FUNCTION {format.btitle}

{ title emphasize
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}
FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}
FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { volume is.kanji.str$
	{ volume }
	{ is.kanji.entry
	    {"$BBh(B" volume * "$B4,(B" *}
	    {"Vol." volume tie.or.space.connect}
	  if$
	}
      if$
      series empty$
	'skip$
	{ series is.kanji.str$
	    { volume empty$
		{series swap$ * }

		{series ", " * swap$ * }

	      if$
	    }
	    { " of " * series emphasize * }
	  if$
	}
      if$
      "volume and number" number either.or.check
    }
  if$
}
FUNCTION {format.number.series}
{ volume empty$
    { number empty$
	{ series field.or.null }
	{ number is.kanji.str$ 
	    { number }
	    {"No." number tie.or.space.connect}
	  if$
	  series empty$
	    { "there's a number but no series in " cite$ * warning$ }
	    { series is.kanji.str$

	        { series ", " * swap$ * }

	        { " in " * series * }
	      if$
	    }
	  if$
	}
      if$
    }
    { "" }
  if$
}
FUNCTION {format.edition}
{ edition empty$
    { "" }
    { edition is.kanji.str$
	{ edition }
        { is.kanji.entry
	    {"$BBh(B" edition * "$BHG(B" *}
	    { output.state mid.sentence =
	      { edition "l" change.case$ " edition" * }
	      { edition "t" change.case$ " edition" * }
              if$
	    }
	  if$
        }
      if$
    }
  if$
}


FUNCTION {first.page}
{ 't :=
	""
	{  t empty$ not t #1 #1 substring$ "-" = not and }
	{ t #1 #1 substring$ *
	t #2 global.max$ substring$ 't :=
	}
	while$
}


INTEGERS { multiresult }
FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
	{ #1 'multiresult := }
	{ t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}
FUNCTION {format.pages}
{ pages duplicate$ empty$
    { "" }
    { duplicate$ multi.page.check

 	{ "" swap$ first.page }
	{ "" swap$ }

      if$
       tie.or.space.connect 
    }
  if$
}


FUNCTION {format.vol.num.pages}
{ volume empty$
     {""}


     { volume is.kanji.str$
        {volume  ", " * }
        {"" volume bold tie.or.space.connect ", " * }
       if$
     }


  if$
  number empty$
    'skip$

    { number is.kanji.str$
        {number *}
        {"" number tie.or.space.connect *}
      if$

      volume empty$
	{ "there's a number but no volume in " cite$ * warning$ }
	'skip$
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
	{ pop$ format.pages }
	{ number empty$

 	    { format.pages * }
 	    { ", " * format.pages * }

	  if$
	}
      if$
    }
  if$
}

FUNCTION {format.vol.pages}
{ volume empty$
	{""}
	
	{ volume is.kanji.str$
		{ volume  " , " * }
		{"" volume bold tie.or.space.connect ", " * }
		if$ 
	}		
	if$
	
	pages empty$
	'skip$
	{ duplicate$ empty$
		{ pop$ format.pages }
		{ number empty$		
			{ format.pages * }
			{ "" * format.pages * }		
		if$
		}
		if$
	}
	if$
}


FUNCTION {word.space}
{
	"\ "
}


FUNCTION {bibinfo.command} { "\bibinfo " }
FUNCTION {bibfield.command}{ "\bibfield "}

FUNCTION {bibinfo.check}
{ swap$
	duplicate$ missing$
	{
	pop$
	pop$ ""
	}{
	duplicate$ empty$
	{
	swap$ pop$
	}{
	swap$
	bibinfo.command "{" * swap$ * "} {" * swap$ * "}" *
	}
	if$
	}
	if$
}

FUNCTION {volnum.punct}
{
	","
	word.space *
}

FUNCTION {format.journal.pages}
{ pages duplicate$ empty$ 'pop$
	{ swap$ duplicate$ empty$
	{ pop$ pop$ format.pages }
	{ volnum.punct *
	swap$
	control.pages duplicate$ #0 < {
	pop$ pop$
	}{
	#0 >
	{
	n.dashify
	}{
	first.page
	} if$
	} if$
	"pages" bibinfo.check
	*
	}
	if$
	}
	if$
}


FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
	{ chapter is.kanji.str$
	    { "" }
	    { is.kanji.entry
		{"$B>O(B"}
		{"chapter"}
	      if$
	    }
	  if$
	}
	{ type "l" change.case$ }
      if$
      chapter is.kanji.str$ not is.kanji.entry and
          {"$BBh(B" chapter * swap$ *}
          { chapter is.kanji.str$
		{chapter *}
		{chapter tie.or.space.connect}
	    if$
	  }
      if$
      pages empty$
	'skip$

	{ ", " * format.pages * }

      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
 	{ booktitle is.kanji.str$
 	    { " " booktitle emphasize * }

 	    { "In " booktitle emphasize * }

 	  if$
 	}
 	{ booktitle is.kanji.str$

 	    { " " format.editors * ", " * booktitle * }


 	    { "In " format.editors * ", " * booktitle emphasize * }

 	  if$
 	}
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and



    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}
FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}
FUNCTION {format.tr.number}
{ type empty$
    { "Technical Report" }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}
FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
	{ "need key or journal for " cite$ * " to crossref " * crossref *
	  warning$
	  ""
	}
 	{ title is.kanji.str$
 	    { " " journal *  }

  	    { "In {\em " journal * "\/}" * }

          if$
	}
      if$
    }
    { title is.kanji.str$
 	{ " " key * }

  	{ "In " key * }

      if$
    }
  if$
  " \cite{" * crossref * "}" *
}
FUNCTION {format.crossref.editor}
{ editor is.kanji.str$

     {editor #1 "{ff}" format.name$ duplicate$

      empty$
 	{pop$ editor #1 "{ll}" format.name$}
 	'skip$
      if$
      }

      {editor #1 "{vv~}{ll}" format.name$}

  if$
  editor num.names$ duplicate$
  #2 >
    { editor is.kanji.str$

	  {pop$ "$B$[$+(B" *} {pop$ ", et~al." * } if$

    }
    { #2 <
	'skip$

	{ editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =

 	    { editor is.kanji.str$

 		{"$B$[$+(B" *} {", et~al." * } if$

 	    }
 	    { editor is.kanji.str$
 		{

		  ", " *

 		   editor #2 "{ff}" format.name$ duplicate$
 		   empty$
 			{pop$ editor #2 "{ll}" format.name$}
 			'skip$
 		   if$
 		 *
 		}
 		{" and " * editor #2 "{vv~}{ll}" format.name$ * }
 	      if$
 	    }
	  if$
	}
      if$
    }
  if$
}
FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
       title is.kanji.str$

 	{"  "} {"In "} if$

    }
    { volume is.kanji.str$
	{ volume }
	{ is.kanji.entry
	    {"$BBh(B" volume * "$B4,(B" *}
	    {"Vol." volume tie.or.space.connect " of " *  }
	  if$
	}
      if$
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
	{ series empty$
	    { "need editor, key, or series for " cite$ * " to crossref " *
	      crossref * warning$
	      "" *
	    }

	    { series is.kanji.str$

		{ series ", " * swap$ * }

	        { "{\em " * series * "\/}" * }
	      if$
	    }

	  if$
	}
	{ key * }
      if$
    }
    { format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}
FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
	{ booktitle empty$
	    { "need editor, key, or booktitle for " cite$ * " to crossref " *
	      crossref * warning$
	      ""
	    }
 	    { booktitle is.kanji.str$
 		{ booktitle }

 		{"In {\em " booktitle * "\/}" * }

 	       if$
 	    }
	  if$
	}

	{ "In " key * }

      if$
    }
    { title is.kanji.str$
 	{" " format.crossref.editor * }

 	{"In " format.crossref.editor * }

      if$
    }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {doi.base}
	{
		"https://doi.org/"
	}

FUNCTION {doi.base.command}
	{
		"http://dx.doi.org/"
	}

FUNCTION {noop.command}
	{
		"\href"
	}


FUNCTION {href.command}
	{
		"\href "
	}

FUNCTION {link.tag.open}
	{
		doi duplicate$ empty$
		{
			pop$
			url duplicate$ empty$
			{
				pop$ "" noop.command
			}{
				href.command
			}
			if$
		}
	{
		"https://doi.org/" swap$ *
		href.command
	}
	if$
	"{" * swap$ * "} {" *
	}

FUNCTION {link.tag.shut}
{
"}"
}

FUNCTION {link.open}
	{
		link.tag.open output.nopunct
	}

FUNCTION {link.shut}
	{
		link.tag.shut *
	}
	
FUNCTION {lparen.tag}
	{
	" ("
	}

FUNCTION {rparen.tag}
	{
	")"
	}

FUNCTION {lparen}
	{
	lparen.tag *
	}
FUNCTION {rparen}
	{
	rparen.tag *
	}


FUNCTION {article}	%--このFUNCTIONに書かれた順に参考文献に表示されます(デフォルトは著者名, タイトル, 雑誌名 巻数(bold), ページ, (年))。
{ output.bibitem
  format.authors "author" output.check	%--著者名
  new.block
  format.title "title" output.check		%--タイトル(消したい場合はコメントアウト)
%  new.block
  crossref missing$
    { link.open
      journal "journal" output.checkNONEcomma		%--雑誌名	※「journal emphasize "journal" output.check」とすれば、雑誌名を斜体にできます。
%      format.vol.num.pages output
%      format.date "year" output.check
      before.all 'output.state :=
      format.vol.pages output.nonnullNONEcomma		%--巻数、ページ
%      format.journal.pages
      format.OnlyYear "year" output.checkNONEcomma		%--(年)
      link.shut
}
    { format.article.crossref output.nonnull
    
      format.pages output
    }
  if$

  new.block
  note output
  fin.entry
}

FUNCTION {book}	%--書籍を引用する場合はこっち。
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
      if$
    }
  if$
  new.block
  link.open
  format.btitle "title" output.checkNONEcomma
  link.shut
  crossref missing$
    { format.bvolume output
      new.block
      format.number.series output
%      new.sentence

	  lparen
      publisher "publisher" output.nNONE
      address output
    }
    { new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output

  format.bOnlyYear "year" output.check
  rparen
  new.block
  note output
  fin.entry
}
FUNCTION {booklet}
{ output.bibitem
  format.authors output
  new.block
  format.title "title" output.check
  howpublished address new.block.checkb
  howpublished output
  address output
  format.date output

  new.block
  note output
  fin.entry
}
FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
      if$
    }
  if$
  new.block
  format.btitle "title" output.check
  crossref missing$
    { format.bvolume output

      format.chapter.pages "chapter and pages" output.check

      new.block
      format.number.series output

      new.sentence

      publisher "publisher" output.check
      address output
    }

    { format.chapter.pages "chapter and pages" output.check

      new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  format.date "year" output.check


  new.block
  note output
  fin.entry
}
FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output


      format.chapter.pages output



      new.sentence

      publisher "publisher" output.check
      address output
      format.edition output

      format.date "year" output.check

    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$

  new.block
  note output
  fin.entry
}
FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output


      format.pages output



      address empty$
	{ organization publisher new.sentence.checkb

	  organization output

	  publisher output

	  format.date "year" output.check

	}
	{ address output.nonnull

	  format.date "year" output.check


	  new.sentence

	  organization output

	  publisher output

	}
      if$
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$

  new.block
  note output
  fin.entry
}
FUNCTION {conference} { inproceedings }
FUNCTION {manual}
{ output.bibitem
  author empty$
    { organization empty$
	'skip$
	{ organization output.nonnull
	  address output
	}
      if$
    }
    { format.authors output.nonnull }
  if$
  new.block
  format.btitle "title" output.check
  author empty$
    { organization empty$
	{ address new.block.checka
	  address output
	}
	'skip$
      if$
    }
    { organization address new.block.checkb
      organization output
      address output
    }
  if$
  format.edition output
  format.date output

  new.block
  note output
  fin.entry
}
FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  "Master's thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check

  new.block
  note output
  fin.entry
}
FUNCTION {misc}
{ output.bibitem
  format.authors output
  title howpublished new.block.checkb
  format.title output
  howpublished new.block.checka
  howpublished output
  format.date output

  new.block
  note output
  fin.entry
  empty.misc.check
}
FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.btitle "title" output.check
  new.block
  "PhD thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check

  new.block
  note output
  fin.entry
}
FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization output }
    { format.editors output.nonnull }
  if$
  new.block
  format.btitle "title" output.check
  format.bvolume output
  format.number.series output
  address empty$
    { editor empty$
	{ publisher new.sentence.checka }
	{ organization publisher new.sentence.checkb
	  organization output
	}
      if$
      publisher output
      format.date "year" output.check

    }
    { address output.nonnull
      format.date "year" output.check


      new.sentence

      editor empty$
	'skip$
	{ organization output }
      if$
      publisher output
    }
  if$
  new.block
  note output
  fin.entry
}
FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  format.tr.number output.nonnull
  institution "institution" output.check
  address output
  format.date "year" output.check

  new.block
  note output
  fin.entry
}
FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  note "note" output.check
  format.date output
  fin.entry
}
FUNCTION {default.type} { misc }

MACRO {jan} {"January"}
MACRO {feb} {"February"}
MACRO {mar} {"March"}
MACRO {apr} {"April"}
MACRO {may} {"May"}
MACRO {jun} {"June"}
MACRO {jul} {"July"}
MACRO {aug} {"August"}
MACRO {sep} {"September"}
MACRO {oct} {"October"}
MACRO {nov} {"November"}
MACRO {dec} {"December"}

 %-------------------------------------------------------------------
% Begin module:
% \ProvidesFile{physjour.mbs}[2002/01/14 2.2 (PWD)]
MACRO {aa}{"Astron. \& Astrophys."}
MACRO {aasup}{"Astron. \& Astrophys. Suppl. Ser."}
MACRO {aj} {"Astron. J."}
MACRO {aph} {"Acta Phys."}
MACRO {advp} {"Adv. Phys."}
MACRO {ajp} {"Amer. J. Phys."}
MACRO {ajm} {"Amer. J. Math."}
MACRO {amsci} {"Amer. Sci."}
MACRO {anofd} {"Ann. Fluid Dyn."}
MACRO {am} {"Ann. Math."}
MACRO {ap} {"Ann. Phys. (NY)"}
MACRO {adp} {"Ann. Phys. (Leipzig)"}
MACRO {ao} {"Appl. Opt."}
MACRO {apl} {"Appl. Phys. Lett."}
MACRO {app} {"Astroparticle Phys."}
MACRO {apj} {"Astrophys. J."}
MACRO {apjsup} {"Astrophys. J. Suppl."}
MACRO {apss} {"Astrophys. Space Sci."}
MACRO {araa} {"Ann. Rev. Astron. Astrophys."}
MACRO {baas} {"Bull. Amer. Astron. Soc."}
MACRO {baps} {"Bull. Amer. Phys. Soc."}
MACRO {cmp} {"Comm. Math. Phys."}
MACRO {cpam} {"Commun. Pure Appl. Math."}
MACRO {cppcf} {"Comm. Plasma Phys. \& Controlled Fusion"}
MACRO {cpc} {"Comp. Phys. Comm."}
MACRO {cqg} {"Class. Quant. Grav."}
MACRO {cra} {"C. R. Acad. Sci. A"}
MACRO {fed} {"Fusion Eng. \& Design"}
MACRO {ft} {"Fusion Tech."}
MACRO {grg} {"Gen. Relativ. Gravit."}
MACRO {ieeens} {"IEEE Trans. Nucl. Sci."}
MACRO {ieeeps} {"IEEE Trans. Plasma Sci."}
MACRO {ijimw} {"Interntl. J. Infrared \& Millimeter Waves"}
MACRO {ip} {"Infrared Phys."}
MACRO {irp} {"Infrared Phys."}
MACRO {jap} {"J. Appl. Phys."}
MACRO {jasa} {"J. Acoust. Soc. America"}
MACRO {jcp} {"J. Comp. Phys."}
MACRO {jetp} {"Sov. Phys.--JETP"}
MACRO {jfe} {"J. Fusion Energy"}
MACRO {jfm} {"J. Fluid Mech."}
MACRO {jmp} {"J. Math. Phys."}
MACRO {jne} {"J. Nucl. Energy"}
MACRO {jnec} {"J. Nucl. Energy, C: Plasma Phys., Accelerators, Thermonucl. Res."}
MACRO {jnm} {"J. Nucl. Mat."}
MACRO {jpc} {"J. Phys. Chem."}
MACRO {jpp} {"J. Plasma Phys."}
MACRO {jpsj} {"J. Phys. Soc. Japan"}
MACRO {jsi} {"J. Sci. Instrum."}
MACRO {jvst} {"J. Vac. Sci. \& Tech."}
MACRO {nat} {"Nature"}
MACRO {nature} {"Nature"}
MACRO {nedf} {"Nucl. Eng. \& Design/Fusion"}
MACRO {nf} {"Nucl. Fusion"}
MACRO {nim} {"Nucl. Inst. \& Meth."}
MACRO {nimpr} {"Nucl. Inst. \& Meth. in Phys. Res."}
MACRO {np} {"Nucl. Phys."}
MACRO {npb} {"Nucl. Phys. B"}
MACRO {nt/f} {"Nucl. Tech./Fusion"}
MACRO {npbpc} {"Nucl. Phys. B (Proc. Suppl.)"}
MACRO {inc} {"Nuovo Cimento"}
MACRO {nc} {"Nuovo Cimento"}
MACRO {pf} {"Phys. Fluids"}
MACRO {pfa} {"Phys. Fluids A: Fluid Dyn."}
MACRO {pfb} {"Phys. Fluids B: Plasma Phys."}
MACRO {pl} {"Phys. Lett."}
MACRO {pla} {"Phys. Lett. A"}
MACRO {plb} {"Phys. Lett. B"}
MACRO {prep} {"Phys. Rep."}
MACRO {pnas} {"Proc. Nat. Acad. Sci. USA"}
MACRO {pp} {"Phys. Plasmas"}
MACRO {ppcf} {"Plasma Phys. \& Controlled Fusion"}
MACRO {phitrsl} {"Philos. Trans. Roy. Soc. London"}
MACRO {prl} {"Phys. Rev. Lett."}
MACRO {pr} {"Phys. Rev."}
MACRO {physrev} {"Phys. Rev."}
MACRO {pra} {"Phys. Rev. A"}
MACRO {prb} {"Phys. Rev. B"}
MACRO {prc} {"Phys. Rev. C"}
MACRO {prd} {"Phys. Rev. D"}
MACRO {pre} {"Phys. Rev. E"}
MACRO {ps} {"Phys. Scripta"}
MACRO {procrsl} {"Proc. Roy. Soc. London"}
MACRO {rmp} {"Rev. Mod. Phys."}
MACRO {rsi} {"Rev. Sci. Inst."}
MACRO {science} {"Science"}
MACRO {sciam} {"Sci. Am."}
MACRO {sam} {"Stud. Appl. Math."}
MACRO {sjpp} {"Sov. J. Plasma Phys."}
MACRO {spd} {"Sov. Phys.--Doklady"}
MACRO {sptp} {"Sov. Phys.--Tech. Phys."}
MACRO {spu} {"Sov. Phys.--Uspeki"}
MACRO {st} {"Sky and Telesc."}
% End module: physjour.mbs
%-------------------------------------------------------------------
% Begin module:
% \ProvidesFile{geojour.mbs}[2002/07/10 2.0h (PWD)]
MACRO {aisr} {"Adv. Space Res."}
MACRO {ag} {"Ann. Geophys."}
MACRO {anigeo} {"Ann. Geofis."}
MACRO {angl} {"Ann. Glaciol."}
MACRO {andmet} {"Ann. d. Meteor."}
MACRO {andgeo} {"Ann. d. Geophys."}
MACRO {andphy} {"Ann. Phys.-Paris"}
MACRO {afmgb} {"Arch. Meteor. Geophys. Bioklimatol."}
MACRO {atph} {"Atm\'osphera"}
MACRO {aao} {"Atmos. Ocean"}
MACRO {ass}{"Astrophys. Space Sci."}
MACRO {atenv} {"Atmos. Environ."}
MACRO {aujag} {"Aust. J. Agr. Res."}
MACRO {aumet} {"Aust. Meteorol. Mag."}
MACRO {blmet} {"Bound.-Lay. Meteorol."}
MACRO {bams} {"Bull. Amer. Meteorol. Soc."}
MACRO {cch} {"Clim. Change"}
MACRO {cdyn} {"Clim. Dynam."}
MACRO {cbul} {"Climatol. Bull."}
MACRO {cap} {"Contrib. Atmos. Phys."}
MACRO {dsr} {"Deep-Sea Res."}
MACRO {dhz} {"Dtsch. Hydrogr. Z."}
MACRO {dao} {"Dynam. Atmos. Oceans"}
MACRO {eco} {"Ecology"}
MACRO {empl}{"Earth, Moon and Planets"}
MACRO {envres} {"Environ. Res."}
MACRO {envst} {"Environ. Sci. Technol."}
MACRO {ecms} {"Estuarine Coastal Mar. Sci."}
MACRO {expa}{"Exper. Astron."}
MACRO {geoint} {"Geofis. Int."}
MACRO {geopub} {"Geofys. Publ."}
MACRO {geogeo} {"Geol. Geofiz."}
MACRO {gafd} {"Geophys. Astrophys. Fluid Dyn."}
MACRO {gfd} {"Geophys. Fluid Dyn."}
MACRO {geomag} {"Geophys. Mag."}
MACRO {georl} {"Geophys. Res. Lett."}
MACRO {grl} {"Geophys. Res. Lett."}
MACRO {ga} {"Geophysica"}
MACRO {gs} {"Geophysics"}
MACRO {ieeetap} {"IEEE Trans. Antenn. Propag."}
MACRO {ijawp} {"Int. J. Air Water Pollut."}
MACRO {ijc} {"Int. J. Climatol."}
MACRO {ijrs} {"Int. J. Remote Sens."}
MACRO {jam} {"J. Appl. Meteorol."}
MACRO {jaot} {"J. Atmos. Ocean. Technol."}
MACRO {jatp} {"J. Atmos. Terr. Phys."}
MACRO {jastp} {"J. Atmos. Solar-Terr. Phys."}
MACRO {jce} {"J. Climate"}
MACRO {jcam} {"J. Climate Appl. Meteor."}
MACRO {jcm} {"J. Climate Meteor."}
MACRO {jcy} {"J. Climatol."}
MACRO {jgr} {"J. Geophys. Res."}
MACRO {jga} {"J. Glaciol."}
MACRO {jh} {"J. Hydrol."}
MACRO {jmr} {"J. Mar. Res."}
MACRO {jmrj} {"J. Meteor. Res. Japan"}
MACRO {jm} {"J. Meteor."}
MACRO {jpo} {"J. Phys. Oceanogr."}
MACRO {jra} {"J. Rech. Atmos."}
MACRO {jaes} {"J. Aeronaut. Sci."}
MACRO {japca} {"J. Air Pollut. Control Assoc."}
MACRO {jas} {"J. Atmos. Sci."}
MACRO {jmts} {"J. Mar. Technol. Soc."}
MACRO {jmsj} {"J. Meteorol. Soc. Japan"}
MACRO {josj} {"J. Oceanogr. Soc. Japan"}
MACRO {jwm} {"J. Wea. Mod."}
MACRO {lao} {"Limnol. Oceanogr."}
MACRO {mwl} {"Mar. Wea. Log"}
MACRO {mau} {"Mausam"}
MACRO {meteor} {"``Meteor'' Forschungsergeb."}
MACRO {map} {"Meteorol. Atmos. Phys."}
MACRO {metmag} {"Meteor. Mag."}
MACRO {metmon} {"Meteor. Monogr."}
MACRO {metrun} {"Meteor. Rundsch."}
MACRO {metzeit} {"Meteor. Z."}
MACRO {metgid} {"Meteor. Gidrol."}
MACRO {mwr} {"Mon. Weather Rev."}
MACRO {nwd} {"Natl. Weather Dig."}
MACRO {nzjmfr} {"New Zeal. J. Mar. Freshwater Res."}
MACRO {npg} {"Nonlin. Proc. Geophys."}
MACRO {om} {"Oceanogr. Meteorol."}
MACRO {ocac} {"Oceanol. Acta"}
MACRO {oceanus} {"Oceanus"}
MACRO {paleoc} {"Paleoceanography"}
MACRO {pce} {"Phys. Chem. Earth"}
MACRO {pmg} {"Pap. Meteor. Geophys."}
MACRO {ppom} {"Pap. Phys. Oceanogr. Meteor."}
MACRO {physzeit} {"Phys. Z."}
MACRO {pps} {"Planet. Space Sci."}
MACRO {pss} {"Planet. Space Sci."}
MACRO {pag} {"Pure Appl. Geophys."}
MACRO {qjrms} {"Quart. J. Roy. Meteorol. Soc."}
MACRO {quatres} {"Quat. Res."}
MACRO {rsci} {"Radio Sci."}
MACRO {rse} {"Remote Sens. Environ."}
MACRO {rgeo} {"Rev. Geophys."}
MACRO {rgsp} {"Rev. Geophys. Space Phys."}
MACRO {rdgeo} {"Rev. Geofis."}
MACRO {revmeta} {"Rev. Meteorol."}
MACRO {sgp}{"Surveys in Geophys."}
MACRO {sp} {"Solar Phys."}
MACRO {ssr} {"Space Sci. Rev."}
MACRO {tellus} {"Tellus"}
MACRO {tac} {"Theor. Appl. Climatol."}
MACRO {tagu} {"Trans. Am. Geophys. Union (EOS)"}
MACRO {wrr} {"Water Resour. Res."}
MACRO {weather} {"Weather"}
MACRO {wafc} {"Weather Forecast."}
MACRO {ww} {"Weatherwise"}
MACRO {wmob} {"WMO Bull."}
MACRO {zeitmet} {"Z. Meteorol."}
% End module: geojour.mbs
%-------------------------------------------------------------------
% Begin module:
% \ProvidesFile{photjour.mbs}[1999/02/24 2.0b (PWD)]

MACRO {appopt} {"Appl. Opt."}
MACRO {bell} {"Bell Syst. Tech. J."}
MACRO {ell} {"Electron. Lett."}
MACRO {jasp} {"J. Appl. Spectr."}
MACRO {jqe} {"IEEE J. Quantum Electron."}
MACRO {jlwt} {"J. Lightwave Technol."}
MACRO {jmo} {"J. Mod. Opt."}
MACRO {josa} {"J. Opt. Soc. America"}
MACRO {josaa} {"J. Opt. Soc. Amer.~A"}
MACRO {josab} {"J. Opt. Soc. Amer.~B"}
MACRO {jdp} {"J. Phys. (Paris)"}
MACRO {oc} {"Opt. Commun."}
MACRO {ol} {"Opt. Lett."}
MACRO {phtl} {"IEEE Photon. Technol. Lett."}
MACRO {pspie} {"Proc. Soc. Photo-Opt. Instrum. Eng."}
MACRO {sse} {"Solid-State Electron."}
MACRO {sjot} {"Sov. J. Opt. Technol."}
MACRO {sjqe} {"Sov. J. Quantum Electron."}
MACRO {sleb} {"Sov. Phys.--Leb. Inst. Rep."}
MACRO {stph} {"Sov. Phys.--Techn. Phys."}
MACRO {stphl} {"Sov. Techn. Phys. Lett."}
MACRO {vr} {"Vision Res."}
MACRO {zph} {"Z. f. Physik"}
MACRO {zphb} {"Z. f. Physik~B"}
MACRO {zphd} {"Z. f. Physik~D"}

MACRO {CLEO} {"CLEO"}
MACRO {ASSL} {"Adv. Sol.-State Lasers"}
MACRO {OSA}  {"OSA"}
% End module: photjour.mbs

MACRO {acmcs} {"ACM Computing Surveys"}
MACRO {acta} {"Acta Informatica"}
MACRO {cacm} {"Communications of the ACM"}
MACRO {ibmjrd} {"IBM Journal of Research and Development"}
MACRO {ibmsj} {"IBM Systems Journal"}
MACRO {ieeese} {"IEEE Transactions on Software Engineering"}
MACRO {ieeetc} {"IEEE Transactions on Computers"}
MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}
MACRO {ipl} {"Information Processing Letters"}
MACRO {jacm} {"Journal of the ACM"}
MACRO {jcss} {"Journal of Computer and System Sciences"}
MACRO {scp} {"Science of Computer Programming"}
MACRO {sicomp} {"SIAM Journal on Computing"}
MACRO {tocs} {"ACM Transactions on Computer Systems"}
MACRO {tods} {"ACM Transactions on Database Systems"}
MACRO {tog} {"ACM Transactions on Graphics"}
MACRO {toms} {"ACM Transactions on Mathematical Software"}
MACRO {toois} {"ACM Transactions on Office Information Systems"}
MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}
MACRO {tcs} {"Theoretical Computer Science"}
MACRO {tieice} {"$BEE;R>pJsDL?.3X2qO@J8;o(B"}
MACRO {tipsj}  {"$B>pJs=hM}3X2qO@J8;o(B"}
MACRO {jipsj}  {"Journal of Informatin Processing Society of Japan"}
MACRO {jorsj}  {"Journal of the Operations Research Society of Japan"}




READ
FUNCTION {set.is.kanji.entry}
{
  author    field.or.null is.kanji.str$
  title     field.or.null is.kanji.str$ or
  editor    field.or.null is.kanji.str$ or
  journal   field.or.null is.kanji.str$ or
  booktitle field.or.null is.kanji.str$ or
  series    field.or.null is.kanji.str$ or
  'is.kanji.entry :=
}
ITERATE {set.is.kanji.entry}


FUNCTION {bbl.url.prefix}
{
	"\urlprefix "
}

FUNCTION {eprint.command}
{
	"\Eprint "
}

FUNCTION {bbl.shut} { "\BibitemShut " }

FUNCTION {init.bib.eprint}
{
	"\texttt {"
	pop$
	"\providecommand \url  [0]{\begingroup\@sanitize@url \@url }%" write$ newline$
	"\providecommand \@url [1]{\endgroup\@href {#1}{" "}}%" bbl.url.prefix swap$ * * write$ newline$
	"\providecommand " " [0]{URL }%" bbl.url.prefix swap$ * * write$ newline$
	eprint.command "\providecommand " swap$ * "[0]{\href }%" * write$ newline$
}

FUNCTION {init.bib.doi}
{
	"\providecommand \doibase [0]{" doi.base "}%" * * write$ newline$
}

FUNCTION {init.bib.hypertex}
{
	"\providecommand " noop.command "[0]{\@secondoftwo}%" * * write$ newline$
	"\providecommand " href.command "[0]{\begingroup \@sanitize@url \@href}%" * * write$ newline$
	"\providecommand \@href[1]{\@@startlink{#1}\@@href}%" write$ newline$
	"\providecommand \@@href[1]{\endgroup#1\@@endlink}%" write$ newline$
	"\providecommand \@sanitize@url [0]{\catcode `\\12\catcode `\$12\catcode `\&12\catcode `\#12\catcode `\^12\catcode `\_12\catcode `\%12\relax}%" write$ newline$
	"\providecommand \@@startlink[1]{}%" write$ newline$
	"\providecommand \@@endlink[0]{}%"   write$ newline$
}


FUNCTION {warn.bib}
{
}

FUNCTION {init.bib}
{
	warn.bib
	"\makeatletter" write$ newline$
	"\providecommand \@ifxundefined [1]{%"   write$ newline$
	" \@ifx{#1\undefined}"                   write$ newline$
	"}%"                                     write$ newline$
	"\providecommand \@ifnum [1]{%"          write$ newline$
	" \ifnum #1\expandafter \@firstoftwo"    write$ newline$
	" \else \expandafter \@secondoftwo"      write$ newline$
	" \fi"                                   write$ newline$
	"}%"                                     write$ newline$
	"\providecommand \@ifx [1]{%"            write$ newline$
	" \ifx #1\expandafter \@firstoftwo"      write$ newline$
	" \else \expandafter \@secondoftwo"      write$ newline$
	" \fi"                                   write$ newline$
	"}%"                                     write$ newline$
	init.bib.hypertex
	init.bib.eprint
	init.bib.doi
	"\providecommand " bbl.shut * " [1]{\csname bibitem#1\endcsname}%" * write$ newline$
	"\let\auto@bib@innerbib\@empty"          write$ newline$
	"%</preamble>" write$
}

FUNCTION {init.bib.bibinfo}
{
	bibinfo.command  "\providecommand " swap$ * " [0]{\@secondoftwo}%" * write$ newline$
	bibfield.command "\providecommand " swap$ * " [0]{\@secondoftwo}%" * write$ newline$
}

STRINGS { longest.label }
INTEGERS { number.label longest.label.width }
FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}
FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}
EXECUTE {initialize.longest.label}
ITERATE {longest.label.pass}

FUNCTION {begin.bib}

{ 
	id.bst diagn.cmntlog
	preamble$ empty$
	
	'skip$
	{ preamble$ write$ newline$ }
	if$
	"\begin{thebibliography}{"  longest.label  * "}" * write$ newline$
	init.bib
}
EXECUTE {begin.bib}
EXECUTE {init.state.consts}
ITERATE {call.type$}
FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}
EXECUTE {end.bib}