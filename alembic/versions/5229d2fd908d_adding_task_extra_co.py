"""Adding task_extra column

Revision ID: 5229d2fd908d
Revises: 2edcc95ff6f7
Create Date: 2013-03-26 16:28:22.364216

"""

# revision identifiers, used by Alembic.
revision = '5229d2fd908d'
down_revision = '2edcc95ff6f7'

from alembic import op
import sqlalchemy as sa


def upgrade():
    ### commands auto generated by Alembic - please adjust! ###
    op.add_column('jobs', sa.Column('task_extra', sa.Unicode(), nullable=True))
    ### end Alembic commands ###


def downgrade():
    ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('jobs', 'task_extra')
    ### end Alembic commands ###