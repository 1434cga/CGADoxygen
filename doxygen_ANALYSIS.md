# Analysis of source  code
## DoxyDocs and command
pathDoxyDocsPM = perlModAbsPath + "/DoxyDocs.pm";

inline PerlModOutput &openList(const char *s = 0) { open('[', s); return *this; }
inline PerlModOutput &closeList() { close(']'); return *this; }
inline PerlModOutput &openHash(const char *s = 0 ) { open('{', s); return *this; }
inline PerlModOutput &closeHash() { close('}'); return *this; }


cmdMap

Mapper *Mappers::cmdMapper     = new Mapper(cmdMap,TRUE);
Mapper *Mappers::htmlTagMapper = new Mapper(htmlTagMap,FALSE);


# This is problem
## fortunately  all problems is in one following place
- I converted in convert.pl
	- params
	- retvals
- not applied yet
	- templateparam

- Refernce Code
```
void PerlModDocVisitor::visitPre(DocParamSect *s)
{
  leaveText();
  const char *type = 0;
  switch(s->type())
  {
  case DocParamSect::Param:     type = "params"; break;
  case DocParamSect::RetVal:    type = "retvals"; break;
  case DocParamSect::Exception: type = "exceptions"; break;
  case DocParamSect::TemplateParam: type = "templateparam"; break;
  case DocParamSect::Unknown:
    err("unknown parameter section found\n");
    break;
  }
  openOther();
  openSubBlock(type);
}

void PerlModDocVisitor::openSubBlock(const char *s)
{
  leaveText();
  m_output.openList(s);
  m_textblockstart = true;
}

void PerlModDocVisitor::closeSubBlock()
{
  leaveText();
  m_output.closeList();
}

void PerlModDocVisitor::openOther()
{
  // Using a secondary text stream will corrupt the perl file. Instead of
  // printing doc => [ data => [] ], it will print doc => [] data => [].
  /*
  leaveText();
  m_output.openSave();
  */
}

void PerlModDocVisitor::visitPre(DocSimpleSect *s)
{
  {
	  ......
  }
  leaveText();
  m_output.openHash();
  openOther();
  openSubBlock(type);
}

void PerlModDocVisitor::visitPost(DocSimpleSect *)
{
  closeSubBlock();
  closeOther();
  m_output.closeHash();
}
```


- Modified Code  (./perlmodgen.cpp.preparation)
```
void PerlModDocVisitor::visitPre(DocParamSect *s)
{
  leaveText();
  const char *type = 0;
  switch(s->type())
  {
  case DocParamSect::Param:     type = "params"; break;
  case DocParamSect::RetVal:    type = "retvals"; break;
  case DocParamSect::Exception: type = "exceptions"; break;
  case DocParamSect::TemplateParam: type = "templateparam"; break;
  case DocParamSect::Unknown:
    err("unknown parameter section found\n");
    break;
  }
  --> add this line : m_output.openHash();
  openOther();
  openSubBlock(type);
}

void PerlModDocVisitor::visitPost(DocParamSect *)
{
  closeSubBlock();
  closeOther();
  --> add this line : m_output.closeHash();
}
```
