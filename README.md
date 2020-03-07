# PassGen
A GUI-based tool for generating passwords &amp; passphrases

Functions are defined for generating passwords & passphrases using a combination of randomly-selected character ranges (with similar characters e.g. lower-case L & capital i removed) and a variety of dictionary files.

The wordlists used are as follows:
Ogden basic wordlist - http://ogden.basic-english.org/words.html
EFF wordlist - https://www.eff.org/files/2016/07/18/eff_large_wordlist.txt
MIT 10000 most commond words - http://www.mit.edu/~ecprice/wordlist.10000

The current version uses the Ogden list for simple passphrases and the EFF wordlist for strong passphrases. My copies of these wordlists have had all single-character words removed. The MIT wordlist may require additional sanitisation for use in a professional environment as the raw list includes profanities.

The Show-UI module (https://github.com/ShowUI/ShowUI/wiki) is used for the GUI. 
