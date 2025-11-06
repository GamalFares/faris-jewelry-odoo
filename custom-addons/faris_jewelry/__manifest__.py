{
    'name': 'Faris Jewelry Customizations',
    'version': '17.0.1.0.0',
    'category': 'Sales',
    'summary': 'Custom modules for Faris Jewelry Libya',
    'description': """
        Custom modules for Faris Jewelry business in Libya
        - Jewelry-specific product attributes
        - Libyan market customizations
    """,
    'author': 'Faris Jewelry',
    'website': 'https://faris-jewelry.com',
    'depends': ['base', 'sale', 'point_of_sale', 'stock'],
    'data': [
        'views/product_views.xml',
    ],
    'demo': [],
    'installable': True,
    'application': True,
    'auto_install': False,
    'license': 'LGPL-3',
}
