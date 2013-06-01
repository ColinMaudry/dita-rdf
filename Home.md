# Objective

This ontology is not meant to serve as an alternative to the standard DITA 1.2 DTDs and schemas. It translates the semantics of a subset of the vocabulary described in the [DITA 1.2 specification](http://docs.oasis-open.org/dita/v1.2/os/spec/DITA1.2-spec.html) in a format that can be understood in the semantic Web of data.

# Scope

This ontology does not aim at completeness (the whole DITA 1.2 language specification) but at covering the metadata that describes DITA content.

The scope of this ontology includes the meaningful elements and attributes of the [DITA 1.2 vocabulary]. I focused on the metadata elements that are derived from [Dublin core](http://dublincore.org/documents/dcmi-terms/) (title, author, etc) and on the relationships between maps, topics and other documents. 

The scope of this ontology does not include the elements and attributes that bear little semantics, such as (not exhaustive):

* highlight domain (underline, bold, italic, etc.)
* hazard domain
* paragraphs
* tables
* lists
* sections

Also, it does not include (yet) the elements that bear semantics but that my company doesn’t use. I will add them, but you can ping me if you would like to see them added (not exhaustive):

* metadata specific to DITA specializations (learning, machinery, semiconductors, etc.)
* the programming, indexing, software, utilities and UI domains (will add them as separate modules)
* category

# Base ontologies

I have chosen to use the Nepomuk ontologies [NIE](http://www.semanticdesktop.org/ontologies/2007/01/19/nie) and [NFO](http://www.semanticdesktop.org/ontologies/2007/03/22/nfo), and specialize the classes. The distinction they make between data objects (sequences of bytes) and information elements (interpretations) prevents the confusion between:

* the file as data on a file system, that has a path and can be moved or renamed
* the information contained in this file that results from its interpretation (by an XML editor or a PDF viewer).

For instance, let’s consider a DITA topic. If the topic is renamed, can we consider that the topic was modified? The file was modified, but the meaning born by the topic remains untouched.

# Background

This idea came to me when we (NXP Customer Documentation Services) [decided](http://blog.nxp.com/is-linked-data-the-future-of-data-integration-in-the-enterprise/) to publish the metadata of our products and documents as RDF in order to end the siloization of our various data types, define company-wide data models and so that external organizations can easily consume this data.

I have already set up the publication of the metadata about binary documents (data sheets, user manuals, etc.), but since our DITA content is built on complex relationships (topic reuse) and our primary format for translation, we need a proper ontology to describe it. The driver is to provide detailed metrics to authors and greatly facilitate certain internal processes such as the selection of the content to translate. Indeed, we consider that being able to formulate multidimensional queries across topics, maps, users, products and company divisions is a major step ahead.

The driver is consequently mostly internal, but we plan to publish a subset of this metadata when we go live with the whole public data set. Follow [@nxpdata](https://www.twitter.com/nxpdata) to get the latest updates about the linked data published by NXP.

Finally, since the challenges we face are most likely similar to the ones other DITA-enabled organizations face, I decided to share my findings.

_TODO add links to real-life RDF samples._

# Publishing method and availability

The namespace base URI is http://purl.org/dita/ns# and the recommended prefix is **dita:**.

By default this URI returns the XHTML version of the ontology, but it also supports content negotiation for RDF/XML and Turtle (Vapour test).

The ontology is written in a Turtle file and converted to RDF/XML using an public Web service ([http://rdf-translator.appspot.com/](http://rdf-translator.appspot.com/)). Feel free to checkout the Git project and contribute.

A graphical representation of the DITA RDF model can be [viewed on LucidChart](http://bit.ly/DitaRdfLucidChart).

The DITA RDF ontology is licensed under a [CC BY-SA 3.0 unported license](https://creativecommons.org/licenses/by-sa/3.0/). That means you can use it in your own software and products, even commercial one, as long as you specify that I (Colin Maudry) am the author and link back to the project home page ([https://github.com/ColinMaudry/dita-rdf](https://github.com/ColinMaudry/dita-rdf)). You can also modify it and publish it as  new ontologies as long as you mention that you modified my work, link back to the home page and publish your new ontologies under the same or similar terms (that’s the SA, share alike part of the license).

# Contact

* Twitter: [@ColinMaudry](https://www.twitter.com/ColinMaudry)
* Email: colin@zebrana.net