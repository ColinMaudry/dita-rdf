

Thanks for giving a spin to the dita2rdf plugin! Please report bugs and questions to https://github.com/ColinMaudry/dita-rdf/issues.

Installation:
 1. Move the dita2rdf folder to the /plugins directory of your DITA open toolkit installation.
 2. Run 'ant -f integrator.xml strict' at the root of your DITA opent toolkit installation.
 
You should keep reading:
	This plugin enables you to export the metadata of a ditamap and the referenced topics in RDF, via an RDF/XML serialization.
	
	In order to keep the plugin light-weight, with good performance and low code maintenance, I have left the "data safeguards" to a minimum. What is that? It means that this plugin applies the saying "Rubbish in, rubbish out". To be more specific, it means that if the metadata contained in your DITA content is inconsistent, incomplete or simply wrong, it will not be easy to use the resulting RDF.
	
	To avoid issues, here are a couple of things you can do have good output metadata:
	 - make sure all the maps and topics have an @id attribute in the root element, and that it is unique.
	 - make sure all the maps and topics have a @xml:lang attribute in the root element that respects the recommendations of the W3C (http://www.w3.org/International/articles/language-tags/). Due to certain spelling and cultural variants (e.g. date formats), distinguishing Bristish English (en-UK) and American English (en-US) is recommended.
