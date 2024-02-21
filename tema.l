/*** Petrea Andrei 331CC ***/
%option noyywrap stack
%{
    #include <bits/stdc++.h>
    using namespace std;
    int nr = 0;
    stack<int> st;
    vector<string> cuv;
%}

space [ \t\r\n]*

%x GET_TITLE
%x GET_SECTION
%x GET_BOLD
%x GET_ITALIC
%x GET_TTT
%x GET_LINK
%x GET_VERBATIM
%x GET_QUOTATION
%x GET_QUOTATION_FIRST
%x GET_RID_OF_BRACKET
%x GET_RID_OF_TAG
%x UNRECOGNIZED_COMMAND
%x REMOVE_COMMENT
%x REMOVE_NEWLINE

%%
<INITIAL>{space}"\\title"{space}"{"   { BEGIN(GET_TITLE); }
<GET_TITLE>[^}]+    { 
                        cout<<yytext<<endl;  
                        for(int i = 1; i <= 10; i++)
                        {
                            cout<<"=";
                        }
                        cout<<endl;
                        BEGIN(INITIAL);
                    }
<INITIAL>{space}"\\"[a-zA-Z]*"section"{space}"{"    { BEGIN(GET_SECTION); }
<GET_SECTION>[^}]+  { 
                        cout<<yytext<<endl;  
                        for(int i = 1; i <= 10; i++)
                        {
                            cout<<"-";
                        }
                        cout<<endl;
                        BEGIN(INITIAL);
                    }
<INITIAL>"\\textbf"{space}"{"     { BEGIN(GET_BOLD);} 
<GET_BOLD>[^}]+     {
                        cout<<"**"<<yytext<<"**";
                        BEGIN(GET_RID_OF_BRACKET);
                    }
<GET_RID_OF_BRACKET>"}"        { BEGIN(INITIAL); }
<INITIAL>"\\textit"{space}"{"|"\\emph"{space}"{"     { BEGIN(GET_ITALIC); }
<GET_ITALIC>[^}]+   {
                        cout<<"_"<<yytext<<"_";
                        BEGIN(GET_RID_OF_BRACKET);
                    }
<INITIAL>"\\texttt"{space}"{"     { BEGIN(GET_TTT); }
<GET_TTT>[^}]+      {
                        cout<<"`"<<yytext<<"`";
                        BEGIN(GET_RID_OF_BRACKET);
                    }
<INITIAL>"\\href"{space}"{"       { BEGIN(GET_LINK); }
<GET_LINK>[^}]*     {
                        cout<<"["<<yytext<<"]";
                        BEGIN(GET_RID_OF_TAG);
                    }
<GET_RID_OF_TAG>"}{".+"}"  { BEGIN(INITIAL); }                    
<INITIAL>{space}"\\begin"{space}"{verbatim}"{space}   { BEGIN(GET_VERBATIM); }
<GET_VERBATIM>{space}"\\end"{space}"{verbatim}"{space}  { 
                                                            cout<<endl<<endl;
                                                            BEGIN(INITIAL); 
                                                        }
<GET_VERBATIM>[^\n]*    {
                            cout<<"    "<<yytext; 
                            BEGIN(REMOVE_NEWLINE);
                        }
<REMOVE_NEWLINE>\n      { BEGIN(GET_VERBATIM); }
<INITIAL>{space}"\\begin"{space}"{quotation}"{space}    { 
                                                            cuv.clear();
                                                            cout<<endl;
                                                            BEGIN(GET_QUOTATION); 
                                                        }

<GET_QUOTATION>[^ \t\n]*    { cuv.push_back(string(yytext)); }
<GET_QUOTATION>[ \t\n]+       { ; }

<GET_QUOTATION>"\\end"{space}"{quotation}"{space}  { 
                                                        int n = cuv.size();
                                                        cout<<"> ";
                                                        for(int i = 0; i < n; i++)
                                                        {
                                                            if(i % 10 == 0 && i != 0)
                                                            {
                                                                cout<<endl<<"> ";
                                                            }
                                                            cout<<cuv[i]<<" ";
                                                        }
                                                        cout<<endl;
                                                        BEGIN(INITIAL); 
                                                    }  
<INITIAL>{space}"\\begin"{space}"{itemize}"{space}  { 
                                                        nr++;
                                                        cout<<endl;
                                                        for(int i = 1; i <= nr; i++)
                                                        {
                                                            cout<<"\t";
                                                        }
                                                    }
<INITIAL>{space}"\\item"{space} { 
                                    if(st.empty())
                                    {
                                        cout<<"- ";
                                    }
                                    else
                                    {
                                        int virf = st.top();
                                        cout<<virf<<". ";
                                        st.push(virf + 1);
                                    }
                                }
<INITIAL>{space}"\\begin"{space}"{enumerate}"{space}    { 
                                                            cout<<endl; 
                                                            st.push(1);
                                                            stack<int> tempStack = st;
                                                            while (!tempStack.empty()) 
                                                            {
                                                                if (tempStack.top() == 1) 
                                                                {
                                                                    cout<<"\t";
                                                                }
                                                                tempStack.pop(); 
                                                            }
                                                        }
<INITIAL>{space}"\\end"{space}"{itemize}"{space}    { 
                                                        cout<<endl; 
                                                        nr--;
                                                        if(nr != 0)
                                                        {
                                                            cout<<"\t";
                                                        }
                                                    }
<INITIAL>{space}"\\end"{space}"{enumerate}"{space}  { 
                                                        cout<<endl;
                                                        while(st.top() != 1)
                                                        {
                                                            st.pop();
                                                        }
                                                        st.pop();
                                                        if(!st.empty())
                                                        {
                                                            cout<<"\t";
                                                        }
                                                    }
<INITIAL>[^\\}%]+            { cout<<yytext; }

<INITIAL>"\\"[a-zA-Z]*"{"|"\\"[a-zA-Z]*"[" { BEGIN(UNRECOGNIZED_COMMAND); }
<UNRECOGNIZED_COMMAND>[^}]* { BEGIN(UNRECOGNIZED_COMMAND); }
<UNRECOGNIZED_COMMAND>"}"   { BEGIN(UNRECOGNIZED_COMMAND); }
<UNRECOGNIZED_COMMAND>"}"[^{\\]    { 
                                        cout<<yytext[strlen(yytext) - 1];
                                        BEGIN(INITIAL); 
                                    }

<INITIAL>"\\"[a-zA-Z]*  { 
                            cout<<" ";
                            BEGIN(INITIAL);
                        }
<INITIAL>{space}"%"{space}  { BEGIN(REMOVE_COMMENT); }
<REMOVE_COMMENT>[^\n]*      { BEGIN(INITIAL); }

<INITIAL>.|\n   { cout<<endl; }
%%

int main(int argc, char **argv)
{
    if(argc < 2)
    {
        cerr<<"Utilizare: "<<argv[0]<<" <fisier>"<<endl;
        exit(1);
    }
    freopen(argv[1], "r", stdin);
    yylex();
    fclose(stdin);
    return 0;
}
