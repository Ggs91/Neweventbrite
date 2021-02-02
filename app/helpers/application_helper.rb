module ApplicationHelper
  include Pagy::Frontend
  def bootstrap_class_for_flash(type)
    case type
      when 'info' then 'alert-info'
      when 'success' then 'alert-success'
      when 'danger' then 'alert-danger'
      when 'warning' then 'alert-warning'
      when 'error' then 'alert-danger' #override stripe's "error" flash to work with bootstrap
      when 'notice' then 'alert-success' #override devise's "notice" flash to work with bootstrap
      when 'alert' then 'alert-danger' #override devise's "alert" flash to work with bootstrap
    end
  end

  # Format price 
  def pretty_amount(amount_in_cents)
    amount_in_cents == 0 ? 'Free' : number_to_currency(amount_in_cents.to_f / 100, locale: :fr)
  end

  # Avatar helper
  def current_user_avatar
    if current_user.avatar.attached?
      image_tag current_user.avatar, alt: 'avatar', size: 200, style: "display: inline-block"
    else
      image_tag 'default-avatar.png', alt: 'default-avatar', size: 200, style: "display: inline-block"
    end 
  end

  def user_avatar(user, image_class= "", size=200)
    if user.avatar.attached?
      image_tag user.avatar, alt: 'avatar', class: image_class, size: size
    else
      image_tag 'default-avatar.png', alt: 'default-avatar', class: image_class, size: size
    end 
  end

  # Event images 
  def display_event_images(event, image_class= "")
    if event.images.attached?
      event.images.map { |img| image_tag img.blob, alt: 'default-event-image', class: image_class }
    else
      [image_tag('default-event-image.png', alt: 'default-event-image', class: image_class )]
    end 
  end
end
