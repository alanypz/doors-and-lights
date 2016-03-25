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
    /// Interaction logic for ComponentView.xaml
    /// </summary>
    public partial class ComponentView : UserControl
    {

        public ComponentView()
        {
            // init for the page
            InitializeComponent();

            // init for the doors/lights
            initializeComponents();
        }

        void initializeComponents()
        {
            //Get the doors
            object[] lrDoors = null;
            var httpWebRequest = (HttpWebRequest)WebRequest.Create("http://localhost:8080/status/door");
            httpWebRequest.Method = "GET";
            httpWebRequest.ContentType = "application/json";
            WebHeaderCollection myWebHeaderCollection = httpWebRequest.Headers;
            myWebHeaderCollection.Add("Authorization:" + Utility.user.token);
            myWebHeaderCollection.Add("item:door");
            var serializer = new JavaScriptSerializer();
            var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();

            using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
            {
                var result = streamReader.ReadToEnd();
                
                lrDoors = serializer.Deserialize<dynamic>(result);
                
                for(int i=0; i<lrDoors.Length; i++)
                {
                    lrDoors[i] = serializer.Serialize(lrDoors[i]);
                }
            }

            //Get the lights
            object[] lrLights = null;
            httpWebRequest = (HttpWebRequest)WebRequest.Create("http://localhost:8080/status/light");
            httpWebRequest.Method = "GET";
            httpWebRequest.ContentType = "application/json";
            myWebHeaderCollection = httpWebRequest.Headers;
            myWebHeaderCollection.Add("Authorization:" + Utility.user.token);
            myWebHeaderCollection.Add("item:light");
            httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();

            using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
            {
                var result = streamReader.ReadToEnd();

                lrLights = serializer.Deserialize<dynamic>(result);

                for (int i = 0; i < lrLights.Length; i++)
                {
                    lrLights[i] = serializer.Serialize(lrLights[i]);
                }
            }

            //Put them together
            Utility.components = new Component[lrDoors.Length + lrLights.Length];
            Utility.componentButtons = new Button[lrDoors.Length + lrLights.Length];
            
            for(int i=0; i< lrDoors.Length + lrLights.Length; i++)
            {
                if(i<lrDoors.Length)
                {
                    Utility.components[i] = serializer.Deserialize<Component>(lrDoors[i].ToString());
                    Utility.components[i].type = "Door";
                }

                else
                {
                    Utility.components[i] = serializer.Deserialize<Component>(lrLights[i - lrDoors.Length].ToString());
                    Utility.components[i].type = "Light";
                }
 
                Button newComponent = new Button();
                Thickness margin = newComponent.Margin;
                margin.Left = 5;
                margin.Right = 5;
                margin.Top = 9;
                newComponent.Tag = Utility.components[i];

                if(i<lrDoors.Length)
                {
                    newComponent.Content = "Door " + (i + 1).ToString();
                }
                
                else
                {
                    newComponent.Content = "Light " + (i + 1 - lrDoors.Length).ToString();
                }
                
                newComponent.HorizontalAlignment = HorizontalAlignment.Left;
                newComponent.VerticalAlignment = VerticalAlignment.Top;
                newComponent.HorizontalContentAlignment = HorizontalAlignment.Center;
                newComponent.VerticalContentAlignment = VerticalAlignment.Center;
                newComponent.Width = 124;
                newComponent.Height = 30;
                newComponent.Margin = margin;
                newComponent.AddHandler(Button.ClickEvent, new RoutedEventHandler(button_Click));
                Utility.componentButtons[i] = newComponent;
                wp.Children.Add(newComponent);
            }

           
        }


        void button_Click(object sender, EventArgs e)
        {
            Button button = sender as Button;

            if (!SelectionMode.IsChecked.Value)
            {
                Component component = (Component)button.Tag;

                string data =
                    "Type:" + component.type + "\n" +
                    "Number:" + component.number.ToString() + "\n" +
                    "Status: " + component.state + "\n" +
                    "Position: " + component.position
                ;


                ModernDialog.ShowMessage(data, "Component Status", MessageBoxButton.OK);
            }

            else
            {
                for(int i=0; i<Utility.componentButtons.Length; i++)
                {
                    Utility.componentButtons[i].ClearValue(BackgroundProperty);
                }

                button.Background = Brushes.PowderBlue;
                CommandButton.IsEnabled = true;
            }
        }

        private void CommandButton_Click(object sender, RoutedEventArgs e)
        {
            Button selectedComponent = null;

            for(int i=0; i<Utility.componentButtons.Length; i++)
            {
                if(Utility.componentButtons[i].Background == Brushes.PowderBlue)
                {
                    selectedComponent = Utility.componentButtons[i];
                    Utility.componentIndex = i;
                }
            }

            Component component = Utility.components[Utility.componentIndex];

            string data =
                    "Type:" + component.type + "\n" +
                    "Number: " + component.number.ToString() + "\n" +
                    "Position: " + component.position.ToString() + "\n" +
                    "Status: " + component.state + "\n" 
                ;

            ModernDialog commandView = new CommandView(component, data);
            commandView.ShowDialog();
            Utility.componentButtons[Utility.componentIndex].Background = Brushes.Gold;

        }

        private void SelectionMode_Checked(object sender, RoutedEventArgs e)
        {
            for (int i = 0; i < Utility.componentButtons.Length; i++)
            {
                Utility.componentButtons[i].ClearValue(BackgroundProperty);
            }
        }

        private void SelectionMode_Unchecked(object sender, RoutedEventArgs e)
        {
            for (int i = 0; i < Utility.componentButtons.Length; i++)
            {
                Utility.componentButtons[i].ClearValue(BackgroundProperty);
            }

            CommandButton.IsEnabled = false;
        }
    }
}
