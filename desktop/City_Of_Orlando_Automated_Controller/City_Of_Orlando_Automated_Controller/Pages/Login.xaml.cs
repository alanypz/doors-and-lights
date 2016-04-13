using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Net;
using System.IO;
using System.Web.Script.Serialization;
using FirstFloor.ModernUI.Windows.Controls;

namespace City_Of_Orlando_Automated_Controller.Pages
{
    /// <summary>
    /// Interaction logic for Home.xaml
    /// </summary>
    public partial class Login : UserControl
    {
        public Login()
        {
            InitializeComponent();
        }

        public static void login(User user, Login lg)
        {
            var httpWebRequest = (HttpWebRequest)WebRequest.Create(Utility.ip + "/authenticate");
            httpWebRequest.ContentType = "application/json";
            httpWebRequest.Method = "POST";

            var serializer = new JavaScriptSerializer();
            var serializedResult = serializer.Serialize(user);

            using (var streamWriter = new StreamWriter(httpWebRequest.GetRequestStream()))
            {
                streamWriter.Write(serializedResult);
                streamWriter.Flush();
                streamWriter.Close();
            }

            var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();
            using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
            {
                var result = streamReader.ReadToEnd();
                
                Dictionary<string,object> lr = serializer.Deserialize<dynamic>(result);
                Utility.user = user;

                if(lr.ContainsValue(true))
                {
                    BBCodeBlock bs = new BBCodeBlock();
                    user.token = (string)lr["token"];
                    try
                    {
                        bs.LinkNavigator.Navigate(new Uri("/Pages/ComponentView.xaml", UriKind.Relative), lg);
                    }

                    catch(Exception error)
                    {
                        ModernDialog.ShowMessage(error.Message, FirstFloor.ModernUI.Resources.NavigationFailed, MessageBoxButton.OK);
                    }

                    ModernDialog.ShowMessage("Login Successful", "", MessageBoxButton.OK);
                }
                
                else
                {
                    ModernDialog.ShowMessage(lr["msg"].ToString(), "Authentication Failed", MessageBoxButton.OK);
                }
            }
        }

        private void button_Click(object sender, RoutedEventArgs e)
        {
            string email = username.Text.ToString();
            string password = pass.Password;
            User user = new User(email, password);
            login(user, this);
            username.Text = "";
            pass.Password = "";
        }

        private void Signup_Click(object sender, RoutedEventArgs e)
        {

            ModernDialog signup = new Signup();
            signup.ShowDialog();

        }
    }
}
