# PassGen
A GUI-based tool for generating passwords &amp; passphrases

Functions are defined for generating passwords & passphrases using a combination of randomly-selected character ranges (with similar characters e.g. lower-case L & capital i removed) and a variety of dictionary files.

The wordlists used are based on the following wordlists:
Ogden basic wordlist - http://ogden.basic-english.org/words.html
EFF wordlist - https://www.eff.org/files/2016/07/18/eff_large_wordlist.txt
MIT 10000 most commond words - http://www.mit.edu/~ecprice/wordlist.10000

The Ogden list is used for simple passphrases, and the EFF wordlist is used for strong passphrases. My copies of these wordlists have had all single-character words removed. The MIT wordlist may require additional sanitisation for use in a professional environment as the raw list includes profanities.

The tool can be used in three ways:
- a text-based menu, which can be invoked by running the Text-Menu function
- a native Windows Forms GUI, which can be invoked with the Native-GUI function
- a GUI built using the Show-UI module (https://github.com/ShowUI/ShowUI/wiki), which can be invoked with the ShowUI-GUI function 
