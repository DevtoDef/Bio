# -*- coding: utf-8 -*-
from pathlib import Path

path = Path('bio/lib/main.dart')
text = path.read_text(encoding='utf-8')

old_header = "      productSections.add(\r\n        Padding(\r\n          padding: const EdgeInsets.only(bottom: 2.0),\r\n          child: Text(\r\n            category,\r\n            style: const TextStyle(\r\n              fontFamily: 'PatrickHand',\r\n              fontSize: 18,\r\n              fontWeight: FontWeight.bold,\r\n            ),\r\n          ),\r\n        ),\r\n      );\r\n"

new_header = "      productSections.add(\r\n        Padding(\r\n          padding: const EdgeInsets.only(bottom: 0.0),\r\n          child: Text(\r\n            '\\${category} (\\${categoryProducts.length})',\r\n            style: const TextStyle(\r\n              fontFamily: 'PatrickHand',\r\n              fontSize: 18,\r\n              fontWeight: FontWeight.bold,\r\n            ),\r\n          ),\r\n        ),\r\n      );\r\n"

if old_header not in text:
    raise SystemExit('Header block not found for replacement')
text = text.replace(old_header, new_header, 1)

path.write_text(text, encoding='utf-8')
