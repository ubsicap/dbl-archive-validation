def process_countries_section(dom, json_dict):
    countries_sections = dom.xpath("countries")
    if len(countries_sections) > 0:
        countries_section = countries_sections[0]
        json_dict["countries"] = {}
        for country in countries_section.xpath("country"):
            country_isos = country.xpath("iso")
            if len(country_isos) > 0:
                country_iso = country_isos[0].text
                json_dict["countries"][country_iso] = {}
                for field in [
                    "iso",
                    "name",
                    "nameLocal"
                ]:
                    field_nodes = country.xpath(field)
                    if len(field_nodes) > 0:
                        json_dict["countries"][country_iso][field] = str(field_nodes[0].text)
