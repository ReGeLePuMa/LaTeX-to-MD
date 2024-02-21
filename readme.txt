Petrea Andrei 331CC
                        Varianta A

Limbaj ales : C++
Platforma: Linux(WSL)

    In cadrul variantei A a trebuit sa transform un fisier LaTeX intr-un fisier Markdown, dupa anumite reguli.
    Pentru a reusi sa parsez fisierul a trebuit sa folosesc sistemul de stari din FLEX, astfel incat sa pot sa
ma manevrez mai usor prin text. Pentru a face parsarile initiale pentru fiecare regula, si pentru a ignora pe celelalte,
pornesc intotdeauna din starea INITIAL, apoi in functie de ce face match, plec in a parsa regula, dupa care ma intorc inapoi
in INITIAL si o iau de la capat, pana la final.
    Ca sa iau fisierul in linie de comanda (FLEX ia by default de la stdin), m-am folosit de functia ' freopen() ' care 
redirectioneaza intrarea din fisierul dat ca parametru.
    Pentru regulile de \title, pornesc din INITIAL, cu expresia regulata care imi face match pe comanda \title, cu sau fara spatii
astfel incat sa imi permita si daca e '\title {', dupa ma duc in alta stare GET_TITLE, pana la '}' astfel luand textul dintre acolade,
apoi il afisez si pun cele 10 '='.
    Pentru regulile de \*section, procedez la fel, doar ca modific putin ER ca sa imi permita sa am si text intre "\" si "section",
apoi la fel ma duc in alta stare GET_SECTION, pana la '}' astfel luand textul dintre acolade, apoi il afisez si pun cele 10 '-'.
    Pentru regulile de formatare a fontului (bold, italic, emph, cod), procedez similar, facand mai intai match pe comanda cu "{", apoi
luand o alta stare in care sa iau textul dintre acolade, apoi afisandu-l cu formatarea corespunzatoare, si dupa trec intr-o noua stare
ca sa elimin "}" care ramane. (la titlu, subsection, intra pe cazul de "altceva" si punea newline, insa nu pot sa pun newline daca exista dupa
el text).
    Pentru link-uri, gasesc comanda, apoi i-au textul dintre acolade, il afisez, si dupa ma duc sa elimin si cel de al doile set de
"{text}" ce reprezinta textul care ma duce pe link.
    Pentru verbatim, gasesc comanda, apoi intr-o bucla de stari i-au textul linie cu linie mot-a-mot, ii pun tab-ul corespunzator si tot
ma duc pana cand ajung la finalul lui verbatim.
    Pentru modul itemsize, gasesc comanda, incrementez o variablia care imi spune cate tag-uri de itemsize am, ca sa le indentez bine,
si raman tot in INITIAL, deoarece ma bazez pe numar ca sa retin indentarea, si deoarece pot avea itemi cu comenzi din INITIAL si trebuia
sa copiez doate regex-urile in starea noua :).
    Pentru enumerate, pe baza acceleasi idei, doar ca din cauza ca trebuie sa retin o numaratoare, folosesc o stiva. Cand gasesc comanda de 
inceput, adaug 1 in virful stivei(acesta e primul indice la enumerate), si cand gasesc itemi, bag in stiva urmatorul numar. Cand gasesc comanda
de sfarsit, scot din stiva toate numerele pana la 1 inclusiv(astfel punadu-ma la indicele corecte cand ies din liste imbricate). Ca sa gestionez
identarea, a trebuit sa numar cati de 1 am in stiva, lucru realizat prin copierea stivei originale st in alt stiva pe care o parcurg, deoarece in 
C++ stack nu este iterabila din pacate :).
    De observat e ca folosesc aceasi regula pentru ambele liste pentru luarea item-ilor, doar ca in functie de "golitatea" numarului/stivei,
stiu daca e itemsize sau enumerate
    Pentru modul quotation, ma pun la comanda, si iau cuvant cu cuvant intr-un vector, pana cand gasesc comanda de sfarsti,
in care afisez cuvintele, 10 pe linii maxim, si liniile goale separat(Nu merge 100% in totalitate).
    Pentru comentarii, gasesc "%" si dupa ma duc pana la newline, astfel ignorand comentariile.
    Pentru comenzile ce nu intra in calcul, am creat o regula cu 2 regex, in care gasesc "\text{" sau "[text" si dupa 
ciclez pana gasesc ultima "}", luand si caracterul dupa ultima acolada, pe care il afisez, astfel incat sa nu dea newline daca e pe o linie
cu text, sau sa aiba lipit un alt caracter fata de " ".
    Pentru a putea face match pe orice caracter, am folosit expresii regulate ".|/n" in care printez un newline. 
