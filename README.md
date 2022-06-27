# PassGen
A GUI-based tool for generating passwords &amp; passphrases.

Functions are defined for generating passwords & passphrases using a combination of randomly-selected character ranges (with visually similar characters e.g. lower-case L & capital i removed) and a variety of dictionary files.

The wordlists used are based on the following wordlists:
Ogden basic wordlist - http://ogden.basic-english.org/words.html
EFF wordlist - https://www.eff.org/files/2016/07/18/eff_large_wordlist.txt
MIT 10000 most common words - http://www.mit.edu/~ecprice/wordlist.10000

The Ogden list is used for simple passphrases, and the EFF wordlist is used for strong passphrases. The copies of these wordlists provided here have had all single-character words removed. The MIT wordlist may require additional sanitisation for use in a professional environment as the raw list includes profanities.

The tool has a native Windows Forms GUI which is loaded automatically when the tool is run. The default minimum length for passwords and passphrases is 16 characters, though this can be changed within the tool - each generated password and passphrase will be displayed along with its length.