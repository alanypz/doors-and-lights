using FirstFloor.ModernUI.Windows.Controls;
using City_Of_Orlando_Automated_Controller.HelperClasses;
using System;
using System.Collections.Generic;
using System.ComponentModel;
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
using System.Threading;

namespace City_Of_Orlando_Automated_Controller
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : ModernWindow
    {

        public MainWindow()
        {
            InitializeComponent();
            DataContext = this;
            Utility.autoRefresh = false;
            this.WindowState = WindowState.Minimized;
            Thread.Sleep(1000);
            this.WindowState = WindowState.Normal;
        }

        private void ModTab_PreviewMouseLeftButtonUp(object sender,
                                             MouseButtonEventArgs e)
        {
            string link = e.OriginalSource.ToString();
            if (link != null)
            {
                if(link.Contains("logout"))
                {

                    double screenWidth = System.Windows.SystemParameters.PrimaryScreenWidth;
                    double screenHeight = System.Windows.SystemParameters.PrimaryScreenHeight;
                    double windowWidth = this.Width;
                    double windowHeight = this.Height;
                    this.Left = (screenWidth / 2) - (windowWidth / 2);
                    this.Top = (screenHeight / 2) - (windowHeight / 2) - 20;

                    System.Diagnostics.Process.Start(Application.ResourceAssembly.Location);
                    Thread.Sleep(2500);
                    this.WindowState = WindowState.Minimized;
                    Application.Current.Shutdown();
                }
            }
        }

    }
}
