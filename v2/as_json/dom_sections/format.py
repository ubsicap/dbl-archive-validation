from ..metadata_as_json_exception import MetadataAsJsonException


def process_format_section(dom, json_dict, medium):
    if medium is None:
        return
    format_sections = dom.xpath("format")
    if len(format_sections) > 0:
        format_section = format_sections[0]
        json_dict["format"] = {}
        if medium == "text":
            process_text_format_section(format_section, json_dict["format"])
        elif medium == "audio":
            process_audio_format_section(format_section, json_dict["format"])
        elif medium == "video":
            process_video_format_section(format_section, json_dict["format"])
        elif medium == "print":
            process_print_format_section(format_section, json_dict["format"])
        elif medium == "braille":
            process_braille_format_section(format_section, json_dict["format"])
        else:
            raise MetadataAsJsonException("Unknown medium type '{0}'".format(medium))


def process_text_format_section(dom, json_dict):
    for bool_field in [
        "versedParagraphs"
    ]:
        field_nodes = dom.xpath(bool_field)
        if len(field_nodes) > 0:
            json_dict[bool_field] = field_nodes[0].text == "true"


def process_audio_format_section(dom, json_dict):
    for string_field in [
        "compression",
        "trackConfiguration"
    ]:
        field_nodes = dom.xpath(string_field)
        if len(field_nodes) > 0:
            json_dict[string_field] = str(field_nodes[0].text)
    for int_field in [
        "bitRate",
        "bitDepth",
        "samplingRate"
    ]:
        field_nodes = dom.xpath(int_field)
        if len(field_nodes) > 0:
            json_dict[int_field] = int(field_nodes[0].text)


def process_video_format_section(dom, json_dict):
    for string_field in [
        "container"
    ]:
        field_nodes = dom.xpath(string_field)
        if len(field_nodes) > 0:
            json_dict[string_field] = str(field_nodes[0].text)
    process_video_video_stream(dom, json_dict)
    process_video_audio_stream(dom, json_dict)
    process_video_subtitle_stream(dom, json_dict)


def process_video_video_stream(dom, json_dict):
    video_stream_elements = dom.xpath("videoStream")
    if len(video_stream_elements) > 0:
        video_stream_element = video_stream_elements[0]
        json_dict["videoStream"] = {}
        for string_field in [
            "codec",
            "screenResolution"
        ]:
            field_nodes = video_stream_element.xpath(string_field)
            if len(field_nodes) > 0:
                json_dict["videoStream"][string_field] = str(field_nodes[0].text)
        for int_field in [
            "bitRate"
        ]:
            field_nodes = video_stream_element.xpath(int_field)
            if len(field_nodes) > 0:
                json_dict["videoStream"][int_field] = int(field_nodes[0].text)
        for float_field in [
            "frameRate"
        ]:
            field_nodes = video_stream_element.xpath(float_field)
            if len(field_nodes) > 0:
                json_dict["videoStream"][float_field] = float(field_nodes[0].text)



def process_video_audio_stream(dom, json_dict):
    audio_stream_elements = dom.xpath("audioStream")
    if len(audio_stream_elements) > 0:
        audio_stream_element = audio_stream_elements[0]
        json_dict["audioStream"] = {}
        process_audio_format_section(audio_stream_element, json_dict["audioStream"])


def process_video_subtitle_stream(dom, json_dict):
    subtitle_stream_elements = dom.xpath("subtitleStream")
    if len(subtitle_stream_elements) > 0:
        subtitle_stream_element = subtitle_stream_elements[0]
        json_dict["subtitleStream"] = {}



def process_print_format_section(dom, json_dict):
    for string_field in [
        "width",
        "height",
        "scale",
        "orientation",
        "color"
    ]:
        field_nodes = dom.xpath(string_field)
        if len(field_nodes) > 0:
            json_dict[string_field] = str(field_nodes[0].text)
    for int_field in [
        "pageCount"
    ]:
        field_nodes = dom.xpath(int_field)
        if len(field_nodes) > 0:
            json_dict[int_field] = int(field_nodes[0].text)
    for bool_field in [
        "pod"
    ]:
        field_nodes = dom.xpath(bool_field)
        if len(field_nodes) > 0:
            json_dict[bool_field] = field_nodes[0].text == "true"
    process_print_fonts(dom, json_dict)
    process_print_edgespace(dom, json_dict)


def process_print_fonts(dom, json_dict):
    fonts_elements = dom.xpath("fonts")
    if len(fonts_elements) > 0:
        fonts_element = fonts_elements[0]
        json_dict["fonts"] = []
        for font in fonts_element.xpath("font"):
            font_record = {}
            if "type" in font.attrib:
                font_record["type"] = font.attrib["type"]
            if font.text:
                font_record["name"] = font.text
            if len(font_record) > 0:
                json_dict["fonts"] += [font_record]


def process_print_edgespace(dom, json_dict):
    edgespace_elements = dom.xpath("edgeSpace")
    if len(edgespace_elements) > 0:
        edgespace_element = edgespace_elements[0]
        json_dict["edgeSpace"] = {}
        for string_field in [
            "top",
            "bottom",
            "inside",
            "outside"
        ]:
            field_nodes = edgespace_element.xpath(string_field)
            if len(field_nodes) > 0:
                json_dict["edgeSpace"][string_field] = str(field_nodes[0].text)


def process_braille_format_section(dom, json_dict):
    for bool_field in [
        "isContracted"
    ]:
        field_nodes = dom.xpath(bool_field)
        if len(field_nodes) > 0:
            json_dict[bool_field] = field_nodes[0].text == "true"
    process_braille_liblouis(dom, json_dict)
    process_braille_hyphenation(dom, json_dict)
    process_braille_number_sign(dom, json_dict)
    process_braille_continuous_poetry(dom, json_dict)
    process_braille_content(dom, json_dict)
    process_braille_page(dom, json_dict)


def process_braille_liblouis(dom, json_dict):
    liblouis_elements = dom.xpath("liblouis")
    if len(liblouis_elements) > 0:
        liblouis_element = liblouis_elements[0]
        json_dict["liblouis"] = {}
        for string_field in [
            "version"
        ]:
            field_nodes = liblouis_element.xpath(string_field)
            if len(field_nodes) > 0:
                json_dict["liblouis"][string_field] = str(field_nodes[0].text)
        process_braille_liblouis_table(liblouis_element, json_dict["liblouis"])


def process_braille_liblouis_table(dom, json_dict):
    table_elements = dom.xpath("table")
    if len(table_elements) > 0:
        table_element = table_elements[0]
        json_dict["table"] = {}
        for string_field in [
            "source",
            "name"
        ]:
            field_nodes = table_element.xpath(string_field)
            if len(field_nodes) > 0:
                json_dict["table"][string_field] = str(field_nodes[0].text)


def process_braille_hyphenation(dom, json_dict):
    hyphenation_elements = dom.xpath("hyphenationDictionary")
    if len(hyphenation_elements) > 0:
        hyphenation_element = hyphenation_elements[0]
        json_dict["hyphenationDictionary"] = {}
        if "src" in hyphenation_element.attrib:
            json_dict["hyphenationDictionary"]["src"] = str(hyphenation_element.attrib["src"])
        for string_field in [
            "name"
        ]:
            field_nodes = hyphenation_element.xpath(string_field)
            if len(field_nodes) > 0:
                json_dict["hyphenationDictionary"][string_field] = str(field_nodes[0].text)


def process_braille_number_sign(dom, json_dict):
    number_sign_elements = dom.xpath("numberSign")
    if len(number_sign_elements) > 0:
        number_sign_element = number_sign_elements[0]
        json_dict["numberSign"] = {}
        for string_field in [
            "character"
        ]:
            field_nodes = number_sign_element.xpath(string_field)
            if len(field_nodes) > 0:
                json_dict["numberSign"][string_field] = str(field_nodes[0].text)
        for bool_field in [
            "useInMargin"
        ]:
            field_nodes = number_sign_element.xpath(bool_field)
            if len(field_nodes) > 0:
                json_dict["numberSign"][bool_field] = field_nodes[0].text == "true"


def process_braille_continuous_poetry(dom, json_dict):
    continuous_elements = dom.xpath("continuousPoetry")
    if len(continuous_elements) > 0:
        continuous_element = continuous_elements[0]
        json_dict["continuousPoetry"] = {}
        for string_field in [
            "startIndicator",
            "lineIndicator",
            "lineIndicatorSpaced",
            "endIndicator"
        ]:
            field_nodes = continuous_element.xpath(string_field)
            if len(field_nodes) > 0:
                json_dict["continuousPoetry"][string_field] = str(field_nodes[0].text)


def process_braille_content(dom, json_dict):
    content_elements = dom.xpath("content")
    if len(content_elements) > 0:
        content_element = content_elements[0]
        json_dict["content"] = {}
        for string_field in [
            "chapterNumberStyle",
            "verseSeparator",
        ]:
            field_nodes = content_element.xpath(string_field)
            if len(field_nodes) > 0:
                json_dict["content"][string_field] = str(field_nodes[0].text)
        for bool_field in [
            "chapterHeadingsNumberFirst",
            "versedParagraphs",
            "includeIntros"
        ]:
            field_nodes = content_element.xpath(bool_field)
            if len(field_nodes) > 0:
                json_dict["content"][bool_field] = field_nodes[0].text == "true"
        process_braille_content_footnotes(content_element, json_dict["content"])
        process_braille_content_xrefs(content_element, json_dict["content"])
        process_braille_content_character_styles(content_element, json_dict["content"])


def process_braille_content_footnotes(dom, json_dict):
    footnotes_elements = dom.xpath("footnotes")
    if len(footnotes_elements) > 0:
        footnotes_element = footnotes_elements[0]
        json_dict["footnotes"] = {}
        for string_field in [
            "callerSymbol"
        ]:
            field_nodes = footnotes_element.xpath(string_field)
            if len(field_nodes) > 0:
                json_dict["footnotes"][string_field] = str(field_nodes[0].text)


def process_braille_content_xrefs(dom, json_dict):
    xrefs_elements = dom.xpath("crossReferences")
    if len(xrefs_elements) > 0:
        xrefs_element = xrefs_elements[0]
        json_dict["crossReferences"] = {}
        for string_field in [
            "callerSymbol"
        ]:
            field_nodes = xrefs_element.xpath(string_field)
            if len(field_nodes) > 0:
                json_dict["crossReferences"][string_field] = str(field_nodes[0].text)


def process_braille_content_character_styles(dom, json_dict):
    character_elements = dom.xpath("characterStyles")
    if len(character_elements) > 0:
        character_element = character_elements[0]
        json_dict["characterStyles"] = {}
        for string_field in [
            "emphasizedWord",
            "emphasizedPassageStart",
            "emphasizedPassageEnd"
        ]:
            field_nodes = character_element.xpath(string_field)
            if len(field_nodes) > 0:
                json_dict["characterStyles"][string_field] = str(field_nodes[0].text)


def process_braille_page(dom, json_dict):
    page_elements = dom.xpath("page")
    if len(page_elements) > 0:
        page_element = page_elements[0]
        json_dict["page"] = {}
        for int_field in [
            "charsPerLine",
            "linesPerPage",
            "defaultMarginWidth",
            "carryLines"
        ]:
            field_nodes = page_element.xpath(int_field)
            if len(field_nodes) > 0:
                json_dict["page"][int_field] = int(field_nodes[0].text)
        for bool_field in [
            "versoLastLineBlank"
        ]:
            field_nodes = page_element.xpath(bool_field)
            if len(field_nodes) > 0:
                json_dict["page"][bool_field] = field_nodes[0].text == "true"

