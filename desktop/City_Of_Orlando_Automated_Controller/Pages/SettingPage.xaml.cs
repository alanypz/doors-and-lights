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

namespace City_Of_Orlando_Automated_Controller
{
    /// <summary>
    /// Interaction logic for SettingPage.xaml
    /// </summary>
    public partial class SettingPage : UserControl
    {
        public SettingPage()
        {
            InitializeComponent();
        }

        private void autoRefresh_Checked(object sender, RoutedEventArgs e)
        {
            Utility.autoRefresh = true;
        }

        private void autoRefresh_Unchecked(object sender, RoutedEventArgs e)
        {
            Utility.autoRefresh = false;
        }
    }
}
