from odoo import models, fields, api

class ProductTemplate(models.Model):
    _inherit = 'product.template'
    
    jewelry_type = fields.Selection([
        ('gold', 'Gold'),
        ('silver', 'Silver'),
        ('diamond', 'Diamond'),
        ('gemstone', 'Gemstone'),
        ('pearl', 'Pearl'),
    ], string='Jewelry Type')
    
    karat = fields.Float(string='Karat')
    weight_grams = fields.Float(string='Weight (grams)')
    stone_count = fields.Integer(string='Stone Count')
    is_jewelry = fields.Boolean(string='Is Jewelry Item')
