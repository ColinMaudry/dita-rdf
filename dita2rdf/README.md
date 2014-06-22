
Thanks for giving a spin to the dita2rdf [DITA Open Toolkit](http://dita-ot.github.io/) plugin! Please report bugs and questions to https://github.com/ColinMaudry/dita-rdf/issues.

### License

The licensing information can be found in the "license" file. That's the GPL v3, so basically you CAN:
- include this plugin in a commercial product
- modify it
- distribute it
- receive patent rights (if any)

You CANNOT:
- hold me liable if this plugin causes you any trouble, damage, loss, etc.
- modify the license associated with it (= sublicensing)

If you ditribute this plugin or a modified version of it, You MUST:
- Include this license and the copyright notice (Copyright 2013, Colin Maudry)
- Clearly indicate if you make changes to the original code
- Distribute the original AND modified source code

### Installation

1. Extract the content of dita-rdf/dita2rdf/dita2rdf-ditaot-plugin.zip to [DITA-OT]/plugins.
2. Run 'ant -f integrator.xml strict' at the root of your DITA opent toolkit installation.

The new transtype 'rdf' is now available. Send me feedback either at colin@maudry.com or by [opening issues](https://github.com/ColinMaudry/dita-rdf/issues)!
		 

This plugin enables you to export the metadata of a ditamap and the referenced topics in RDF, via an RDF/XML serialization.

Because the development of this plugin started in late-2013, it exclusively uses XSLT 2.0 and consequently only works with Saxon 9.x+ and other XSLT 2.0 compliant processors.

In order to keep the plugin light-weight, with good performance and low code maintenance, I have left the "data safeguards" to a minimum. What is that? It means that this plugin applies the saying "Rubbish in, rubbish out". To be more specific, it means that if the metadata contained in your DITA content is inconsistent, incomplete or simply wrong, this plugin will not fix it and it will not be easy to use the resulting RDF.

To avoid issues, here are a couple of things you can do have good output metadata:
 - make sure all the maps and topics have an @id attribute in the root element, and that it is unique.
 - make sure all the maps and topics have a @xml:lang attribute in the root element that respects the recommendations of the W3C (http://www.w3.org/International/articles/language-tags/). Due to certain spelling and cultural variants (e.g. date formats), distinguishing British English (en-UK) and American English (en-US) is recommended.
