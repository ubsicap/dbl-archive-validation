def process_archive_status_section(dom, json_dict):
    archive_status_sections = dom.xpath("archiveStatus")
    if len(archive_status_sections) > 0:
        archive_status_section = archive_status_sections[0]
        json_dict["archiveStatus"] = {}
        for field in [
            "bundleCreatorName",
            "archivistName",
            "dateArchived",
            "dateUpdated",
            "comments"
        ]:
            field_nodes = archive_status_section.xpath(field)
            if len(field_nodes) > 0:
                json_dict["archiveStatus"][field] = str(field_nodes[0].text)
