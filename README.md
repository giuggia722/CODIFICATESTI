# CODIFICATESTI
Progetto di Codifica di Testi, 2023/2024

per la validazione well-formed è stato usato dom.Counter:  java -cp ".:*" dom.Counter -v rassegna_settimanale.xml 

per la trasfromazione in html è stato usato saxon+xmlresolver:  java -cp "saxon-he-12.5.jar:xmlresolver-6.0.11.jar" net.sf.saxon.Transform -s:rassegna_settimanale.xml -xsl:template.xsl -o:output.html

