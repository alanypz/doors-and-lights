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

namespace City_Of_Orlando_Automated_Controller.Pages.Settings
{
    /// <summary>
    /// Interaction logic for About.xaml
    /// </summary>
    public partial class About : UserControl
    {
        public About()
        {
            InitializeComponent();

            Header.Text = "Senior Design Team";
            Header.FontSize = 24;
            Header.FontWeight = FontWeights.Bold;
            Header.TextDecorations = TextDecorations.Underline;

            Team.Text = "Zach Duckett";

            Me.Text = "Justin MacKenzie";
            Me.FontWeight = FontWeights.Bold;

            Team2.Text = "Marcus Moraes";
            Team3.Text = "Alan Yepez";

            Me.HorizontalAlignment = HorizontalAlignment.Center;
            Me.VerticalAlignment = VerticalAlignment.Top;
            Team2.HorizontalAlignment = HorizontalAlignment.Center;
            Team2.VerticalAlignment = VerticalAlignment.Top;
            Team3.HorizontalAlignment = HorizontalAlignment.Center;
            Team3.VerticalAlignment = VerticalAlignment.Top;
            Team.HorizontalAlignment = HorizontalAlignment.Center;
            Team.VerticalAlignment = VerticalAlignment.Top;
            Header.HorizontalAlignment = HorizontalAlignment.Center;
            Header.VerticalAlignment = VerticalAlignment.Top;
        }
    }
}
