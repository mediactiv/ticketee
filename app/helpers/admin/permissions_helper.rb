module Admin::PermissionsHelper
  def permissions
    {
        'view'=> 'View',
        'edit' => 'Edit',
        'delete' => 'Delete',
        'create tickets' => 'Create Tickets',
        'edit tickets' => 'Edit Tickets',
        'delete tickets' => 'Delete Tickets'
    }
  end
end
