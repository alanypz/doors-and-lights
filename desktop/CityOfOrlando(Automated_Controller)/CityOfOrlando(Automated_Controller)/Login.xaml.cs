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

namespace CityOfOrlando_Automated_Controller_
{
    /// <summary>
    /// Interaction logic for Login.xaml
    /// </summary>
    public partial class Login : Page
    {
        private const string COMPONENT_VIEW = "ComponentView.xaml";

        public Login()
        {
            InitializeComponent();
        }

        private void Authenticate_Click(object sender, RoutedEventArgs e)
        {
            MessageBox.Show("Login Successful");
            NavigationService.Navigate(new Uri(COMPONENT_VIEW, UriKind.RelativeOrAbsolute));
        }
    }
}
