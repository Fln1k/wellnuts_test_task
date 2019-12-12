defmodule MyApp.Email do
  use Bamboo.Phoenix, view: MyApp.EmailView

  def welcome_text_email(email_address, link) do
    new_email()
    |> to(email_address)
    |> from("WellnutsEvents@gmail.com")
    |> subject("WellnutsEvents Login")
    |> text_body("your login link: " <> link)
  end
end
